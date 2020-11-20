extends Spatial

onready var wing_flap_sound_clip = load("res://import/audio/action/flap1.wav")
onready var hurt_sound_clip = load("res://import/audio/action/gulp2.wav")

var level;

# Player
onready var kine_body: KinematicBody = get_node("KineBody")
onready var player_object: Spatial = get_node("KineBody/Head/guacamaya_redblue")
onready var player_animation: AnimationPlayer = player_object.get_node("AnimationPlayer")

# Camera
export(float) var mouse_sensitivity = 9.0
export(float) var FOV = 100.0
var mouse_axis := Vector2()
onready var head: Spatial = get_node("KineBody/Head")
onready var cam_target: Spatial = get_node("KineBody/Head/CameraTarget")
#onready var cam_body: Spatial = get_node("CamBody")
onready var cam_node: Camera = get_node("KineBody/ClippedCamera")

# Move
var velocity := Vector3()
var direction := Vector3()
var move_axis := Vector2()
var walk_enabled := true
var sprint_enabled := true
var sprinting := false
var friction = 1.0
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
export(int) var SPRINT_JUMP_HEIGHT_CONSTANT = 4
var jump_height = JUMP_HEIGHT_CONSTANT

# Fly
var fly_speed = 3
var fly_accel = 1
var flying := false

var drowning := false
var breath_time := 6

var lives = 3
var damage_hit = false

onready var overlay_underwater = get_node("Foreground/Overlays/underwater")
onready var overlay_underwater_drowning = get_node("Foreground/Overlays/underwater_drowning")
onready var breath_time_bar = get_node("Foreground/Overlays/breath_time_bar")
onready var health_hearts = get_node("Foreground/Stats/grid").get_children()


##################################################
onready var timer = get_node("Foreground/Timer");
onready var foreground_animations = get_node("Foreground/foreground_animations");

var current_timer_callback = ""

func _ready():
	cam_node.fov = FOV
	cam_node.add_exception(kine_body)
	
	
func show_health():
	for heart in health_hearts:
		heart.show()
func hide_health():
	for heart in health_hearts:
		heart.hide()
	
func set_timer(wait_time, timer_callback):
	timer.set_wait_time(wait_time)
	
	if current_timer_callback != timer_callback:
		if current_timer_callback != "":
			timer.disconnect("timeout", self, current_timer_callback)
		current_timer_callback = timer_callback
		timer.connect("timeout", self, timer_callback)
		
	timer.start()
	
func enter_underwater():
	overlay_underwater_drowning.hide()
	overlay_underwater.show()
	
	foreground_animations.play("Drowning")
	
	if !drowning:
		drowning = true
		set_timer(breath_time, "_drown")
	
func _drown():
	if drowning:
		AUDIO_MANAGER.play_sfx(hurt_sound_clip, 0)
		enter_underwater_danger()
		substract_live()
		set_timer(breath_time, "_drown")
	
func exit_underwater():
	foreground_animations.play("unDrown")
	drowning = false
	
	overlay_underwater_drowning.hide()
	overlay_underwater.hide()
	
func enter_underwater_danger():
	overlay_underwater_drowning.show()
	
func die():
	drowning = false
	for node in get_tree().get_nodes_in_group("current_level"):
		node.game_over()
		
func add_live():
	print("+1 live")
	lives += 1
func substract_live():
	print("-1 live")
	if lives - 1 == 0:
		die()
	else:
		get_node("Foreground/Stats/grid/health_heart"+str(lives)).hide()
		lives -= 1
		
func take_damage_hit():
	var a = InputEventKey.new()
	a.scancode = KEY_SPACE
	a.pressed = true # change to false to simulate a key release
	print("trying to press SPACE")
	Input.parse_input_event(a)

func _process(delta: float) -> void:
	cam_node.global_transform = cam_node.global_transform.interpolate_with(cam_target.global_transform, delta * 2)
	
	var lateral_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if	walk_enabled:
		move_axis.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
		move_axis.y = lateral_movement
	
	if	!kine_body.is_on_floor():
		player_object.rotate_z(deg2rad(lateral_movement) * -4)
		cam_target.rotate_z(deg2rad(lateral_movement) * -2)
		
	if player_object.rotation_degrees.z != 0: player_object.rotation_degrees.z *= .98;
	if cam_target.rotation_degrees.z != 0: cam_target.rotation_degrees.z *= .85;


func _physics_process(delta: float) -> void:
	if flying:
		fly(delta)
	else:
		walk(delta)


func _input(event: InputEvent) -> void:		
	if event is InputEventMouseMotion:
		mouse_axis = event.relative
		camera_rotation()
		
	if Input.is_action_pressed("zoom_in"):
		cam_target.translation.z = clamp(cam_target.translation.z - 0.1, 0.5, 1)
	if Input.is_action_pressed("zoom_out"):
		cam_target.translation.z = clamp(cam_target.translation.z + 0.1, 0.5, 1)


func walk(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim = kine_body.get_global_transform().basis
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
	
	if	kine_body.is_on_floor():
		player_animation.play("On_Ground")
	
	# Jump
	var _snap: Vector3
	# if is_on_floor():
	_snap = Vector3(0, -1, 0)
	
	# WINGS RETRACTING
	if Input.is_action_just_pressed("move_jump") or damage_hit:
		damage_hit = false
		AUDIO_MANAGER.play_sfx(wing_flap_sound_clip, 1, -10)
		player_animation.clear_queue() 
		player_animation.stop()
		player_animation.play("Flap_Wings")
		_snap = Vector3(0, 0, 0)
		velocity.y = jump_height
		gravity = GRAVITY_CONSTANT;
		
	# WINGS RETRACTED
	if Input.is_action_pressed("move_jump"):
		if (!player_animation.current_animation):
			player_animation.play("Retract_Wings")
		
	# WINGS TO REST
	if Input.is_action_just_released("move_jump"):
		player_animation.animation_set_next("Flap_Wings", "Hover_State")
		gravity = HOVER_GRAVITY_CONSTANT;
		
		
	# Apply Gravity
	velocity.y -= gravity * delta
	
	# Sprint
	
	# if (Input.is_action_pressed("move_sprint") and can_sprint() and move_axis.x >= 0.5):
	if (Input.is_action_pressed("move_sprint") and can_sprint() and true):
		jump_height = SPRINT_JUMP_HEIGHT_CONSTANT
		speed = SPRINT_FLY_SPEED_CONTSTANT
		cam_node.set_fov(lerp(cam_node.fov, FOV * 1.1, delta * 8))
		sprinting = true
	else:
		jump_height = JUMP_HEIGHT_CONSTANT
		speed = FLY_SPEED_CONTSTANT
		cam_node.set_fov(lerp(cam_node.fov, FOV, delta * 8))
		sprinting = false;
		
	if	kine_body.is_on_floor():
		speed = WALK_SPEED_CONTSTANT
	
	# Acceleration and Deacceleration
	# where would the player go
	var _temp_vel: Vector3 = velocity
	_temp_vel.y = 0
	var _target: Vector3 = direction * speed * friction
	var _temp_accel: float
	if direction.dot(_temp_vel) > 0:
		_temp_accel = acceleration
	else:
		_temp_accel = deacceleration
	if !kine_body.is_on_floor():
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
	var moving = kine_body.move_and_slide_with_snap(velocity, _snap, FLOOR_NORMAL, true, 4, FLOOR_MAX_ANGLE)
	if kine_body.is_on_wall():
		velocity = moving
	else:
		velocity.y = moving.y
		if damage_hit:
			damage_hit = false
			velocity.y += JUMP_HEIGHT_CONSTANT


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
	velocity = kine_body.move_and_slide(velocity)


func camera_rotation() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if mouse_axis.length() > 0:
		var horizontal: float = -mouse_axis.x * (mouse_sensitivity / 100)
		var vertical: float = -mouse_axis.y * (mouse_sensitivity / 100)
		
		mouse_axis = Vector2()
		
		kine_body.rotate_y(deg2rad(horizontal))
		head.rotate_x(deg2rad(vertical))
		
		if	!kine_body.is_on_floor():
			player_object.rotate_z(deg2rad(horizontal))
			cam_target.rotate_z(deg2rad(horizontal))
		
		# Clamp mouse rotation
		var temp_rot: Vector3 = head.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -80, 80)
		head.rotation_degrees = temp_rot

func can_sprint() -> bool:
	return (sprint_enabled)
	# return (sprint_enabled and is_on_floor())

func _on_goal_ring_body_shape_entered(_body_id, _body, _body_shape, _area_shape):
	level.goal_hit()
		
