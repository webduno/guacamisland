extends Spatial

onready var env_clear_day = load("res://assets/env_clear_day.tres")
onready var camera = get_node("../Spawn/Player/InterpolatedsCamera")
onready var sun = get_node("DirectionalLight")

func _ready():
	camera.environment = env_clear_day

# Called every frame. 'delta' is the elapsed time since the previous frame.
func __process(_delta):
	rotate_x(deg2rad(.5))
	camera.environment.background_sky_rotation.x += deg2rad(.5)
	
	if	rotation.x > 0:
		sun.light_energy = clamp(1.5 - rotation.x, 0, 1.5)
		sun.light_indirect_energy = clamp(1.5 - rotation.x, 0, 1.5)
		
		# camera.environment.ambient_light_energy = clamp(1.5 - rotation.x, 0, 1.5)
		camera.environment.background_sky.sun_energy = clamp(rotation.x+1.5, 0, .9)
		camera.environment.background_energy = clamp(1.5 - rotation.x, .1, .9)
	else:
		sun.light_energy = clamp(rotation.x+1.5, 0, 1.5)
		sun.light_indirect_energy = clamp(rotation.x+1.5, 0, 1.5)
		
		# camera.environment.ambient_light_energy = clamp(rotation.x+1.5, 0, 1.5)
		camera.environment.background_sky.sun_energy = clamp(rotation.x+1.5, 0, .9)
		camera.environment.background_energy = clamp(rotation.x+1.5, .1, .9)
