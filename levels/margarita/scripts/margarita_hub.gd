extends Spatial

onready var pause_screen = get_node("../pause_screen")

onready var bg_music = load("res://import/audio/background/Loop-Menu.wav")

onready var challenges = get_node("Challenges")

var lap_count = GLOBAL.difficulty
var remaining_laps = GLOBAL.difficulty
onready var lap_label = find_node("lap_label")
onready var lap_popup_label = find_node("lap_popup_label")
onready var lap_popup_animation = find_node("lap_popup_animation")

onready var player = get_node("../Spawn/Player")
onready var player_kine_body = get_node("../Spawn/Player/KineBody")
onready var player_camera = get_node("../Spawn/Player/KineBody/ClippedCamera")
onready var sun_light = get_node("../Environment/Sun")
onready var environment = load("res://assets/environments/env_clear_day.tres")

func _ready():
	player_camera.environment = environment
	player_camera.environment.background_sky.sun_latitude = sun_light.rotation_degrees.x * -1
	player_camera.environment.background_sky.sun_longitude = -180 - sun_light.rotation_degrees.y
	
	AUDIO_MANAGER.play_music(bg_music, -5)
	AUDIO_MANAGER.set_regular_button_sfx()
	player.level = self
	
	var current_scene = "res://levels/margarita/margarita_hub.tscn"
	pause_screen.current_scene = current_scene
	
	challenges.show()
	for x in challenges.get_children():
		x.targetscene = "res://levels/margarita/"+x.name+".tscn"
	
