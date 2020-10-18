extends KinematicBody

###################-VARIABLES-####################


# Player
var level;
onready var player_object: Spatial = get_node("head_node/guaca_blue")

# Camera
export(float) var mouse_sensitivity = 9.0
export(float) var FOV = 100.0
var mouse_axis := Vector2()
onready var head: Spatial = get_node("head_node")
onready var cam: Camera = get_node("InterpolatedCamera")
onready var cam_target: Spatial = get_node("head_node/camera_target")
# Move
var velocity := Vector3()
var direction := Vector3()
var move_axis := Vector2()
var sprint_enabled := true
var sprinting := false
# Walk
const FLOOR_NORMAL := Vector3(0, 1, 0)
const FLOOR_MAX_ANGLE: float = deg2rad(46.0)
export(float) var GRAVITY_CONSTANT = 20.0
export(float) var HOVER_GRAVITY_CONSTANT = 3.0
var gravity = HOVER_GRAVITY_CONSTANT

export(int) var WALK_SPEED_CONTSTANT = 1
export(int) var SPRINT_WALK_SPEED_CONTSTANT = 2
export(int) var FLY_SPEED_CONTSTANT = 4
export(int) var SPRINT_FLY_SPEED_CONTSTANT = 5
var speed: int

export(int) var acceleration = 5
export(int) var deacceleration = 5
export(float, 0.0, 1.0, 0.05) var air_control = 0.3

export(int) var JUMP_HEIGHT_CONSTANT = 3
export(int) var SPRINT_JUMP_HEIGHT_CONSTANT = 5
var jump_height = JUMP_HEIGHT_CONSTANT
# Fly
var fly_speed = 3
var fly_accel = 1
var flying := false

##################################################

# Called when the node enters the scene tree
func _ready() -> void:
	cam.fov = FOV

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	move_axis.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	move_axis.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	
	var lateral_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if	!is_on_floor():
		player_object.rotate_z(deg2rad(lateral_movement) * -4)
		cam_target.rotate_z(deg2rad(lateral_movement) * -2)
	player_object.rotation_degrees.z *= .98;
	cam_target.rotation_degrees.z *= .85;
	# player_object.rotation_degrees.x *= .9;
	# player_object.rotation_degrees.y *= .9;
	# player_object.rotation_degrees.z *= .9;


# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	if flying:
		fly(delta)
	else:
		walk(delta)


# Called when there is an input event
func _input(event: InputEvent) -> void:		
	if event is InputEventMouseMotion:
		mouse_axis = event.relative
		camera_rotation()
		
	if Input.is_action_pressed("zoom_in"):
		cam_target.translation.z -= .1
	if Input.is_action_pressed("zoom_out"):
		cam_target.translation.z += .1


func walk(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	if	is_on_floor():
		player_object.get_node("AnimationPlayer").play("ArmatureAction 3")
	
	# Jump
	var _snap: Vector3
	# if is_on_floor():
	_snap = Vector3(0, -1, 0)
	
	# WINGS RETRACTING
	if Input.is_action_just_pressed("move_jump"):
		player_object.get_node("AnimationPlayer").stop()
		player_object.get_node("AnimationPlayer").play("ArmatureAction")
		_snap = Vector3(0, 0, 0)
		velocity.y = jump_height
		gravity = GRAVITY_CONSTANT;
		
	# WINGS RETRACTED
	if Input.is_action_pressed("move_jump"):
		if (!player_object.get_node("AnimationPlayer").current_animation):
			player_object.get_node("AnimationPlayer").play("ArmatureAction 2")
		
	# WINGS TO REST
	if Input.is_action_just_released("move_jump"):
		player_object.get_node("AnimationPlayer").play("ArmatureAction")
		gravity = HOVER_GRAVITY_CONSTANT;
		
	
	# Apply Gravity
	velocity.y -= gravity * delta
	
	# Sprint
	
	# if (Input.is_action_pressed("move_sprint") and can_sprint() and move_axis.x >= 0.5):
	if (Input.is_action_pressed("move_sprint") and can_sprint() and true):
		jump_height = SPRINT_JUMP_HEIGHT_CONSTANT
		speed = SPRINT_FLY_SPEED_CONTSTANT
		cam.set_fov(lerp(cam.fov, FOV * 1.1, delta * 8))
		sprinting = true
	else:
		jump_height = JUMP_HEIGHT_CONSTANT
		speed = FLY_SPEED_CONTSTANT
		cam.set_fov(lerp(cam.fov, FOV, delta * 8))
		sprinting = false;
		
	if	is_on_floor():
		speed = WALK_SPEED_CONTSTANT
	
	# Acceleration and Deacceleration
	# where would the player go
	var _temp_vel: Vector3 = velocity
	_temp_vel.y = 0
	var _target: Vector3 = direction * speed
	var _temp_accel: float
	if direction.dot(_temp_vel) > 0:
		_temp_accel = acceleration
	else:
		_temp_accel = deacceleration
	if not is_on_floor():
		_temp_accel *= air_control
	# interpolation
	_temp_vel = _temp_vel.linear_interpolate(_target, _temp_accel * delta)
	velocity.x = _temp_vel.x
	velocity.z = _temp_vel.z
	# clamping (to stop on slopes)
	if direction.dot(velocity) == 0:
		var _vel_clamp := 0.25
		if velocity.x < _vel_clamp and velocity.x > -_vel_clamp:
			velocity.x = 0
		if velocity.z < _vel_clamp and velocity.z > -_vel_clamp:
			velocity.z = 0
	
	# Move
	var moving = move_and_slide_with_snap(velocity, _snap, FLOOR_NORMAL, true, 4, FLOOR_MAX_ANGLE)
	if is_on_wall():
		velocity = moving
	else:
		velocity.y = moving.y


func fly(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim = head.get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction = direction.normalized()
	
	# Acceleration and Deacceleration
	var target: Vector3 = direction * fly_speed
	velocity = velocity.linear_interpolate(target, fly_accel * delta)
	
	# Move
	velocity = move_and_slide(velocity)


func camera_rotation() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if mouse_axis.length() > 0:
		var horizontal: float = -mouse_axis.x * (mouse_sensitivity / 100)
		var vertical: float = -mouse_axis.y * (mouse_sensitivity / 100)
		
		mouse_axis = Vector2()
		
		rotate_y(deg2rad(horizontal))
		head.rotate_x(deg2rad(vertical))
		
		if	!is_on_floor():
			player_object.rotate_z(deg2rad(horizontal))
			cam_target.rotate_z(deg2rad(horizontal/2))
		
		# Clamp mouse rotation
		var temp_rot: Vector3 = head.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -60, 60)
		head.rotation_degrees = temp_rot

func can_sprint() -> bool:
	return (sprint_enabled and true)
	# return (sprint_enabled and is_on_floor())




func _on_goal_ring_body_shape_entered(_body_id, _body, _body_shape, _area_shape):
	level.goal_hit()
		
