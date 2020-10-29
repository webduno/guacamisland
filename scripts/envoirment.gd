extends Spatial

onready var env_clear_day = load("res://assets/env_clear_day.tres")
#onready var camera = get_node("../Spawn/Player/InterpolatedCamera")
#onready var clipped_camera = get_node("../Spawn/Player/KineCamera/Camera")
onready var player_camera = get_node("../Spawn/Player/KineBody/Head/CameraRoot/ClippedCamera")
#onready var player_camera = get_node("../Spawn/Player/KineBody/Camera")
onready var sun = get_node("alt_DirectionalLight")
onready var clouds = get_node("RemoteClouds")

var rotation_speed = .001

func _ready():
	player_camera.environment = env_clear_day
#	camera.environment = env_clear_day


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	rotate_x(deg2rad(.5))
	
	
	rotate_y(deg2rad(rotation_speed))
	clouds.rotate_y(deg2rad(rotation_speed*2))
#	camera.environment.background_sky_rotation.y += deg2rad(rotation_speed)
	player_camera.environment.background_sky_rotation.y += deg2rad(rotation_speed)
	
#	if	rotation.x > 0:
#		sun.light_energy = clamp(1.5 - rotation.x, 0, 1.5)
#		sun.light_indirect_energy = clamp(1.5 - rotation.x, 0, 1.5)
#
#		# camera.environment.ambient_light_energy = clamp(1.5 - rotation.x, 0, 1.5)
#		camera.environment.background_sky.sun_energy = clamp(rotation.x+1.5, 0, .9)
#		camera.environment.background_energy = clamp(1.5 - rotation.x, .1, .9)
#	else:
#		sun.light_energy = clamp(rotation.x+1.5, 0, 1.5)
#		sun.light_indirect_energy = clamp(rotation.x+1.5, 0, 1.5)
#
#		# camera.environment.ambient_light_energy = clamp(rotation.x+1.5, 0, 1.5)
#		camera.environment.background_sky.sun_energy = clamp(rotation.x+1.5, 0, .9)
#		camera.environment.background_energy = clamp(rotation.x+1.5, .1, .9)
