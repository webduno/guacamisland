extends Spatial

onready var pause_screen = get_node("../pause_screen")

onready var bg_music = load("res://import/audio/background/jump and run - tropics.wav")

onready var challenges = get_node("Challenges")

var lap_count = GLOBAL.difficulty
var remaining_laps = GLOBAL.difficulty
onready var lap_label = find_node("lap_label")
onready var lap_popup_label = find_node("lap_popup_label")
onready var lap_popup_animation = find_node("lap_popup_animation")

onready var player = get_node("../Spawn/Player")
onready var player_kine_body = get_node("../Spawn/Player/KineBody")

func _ready():
	AUDIO_MANAGER.play_music(bg_music, -15)
	AUDIO_MANAGER.set_regular_button_sfx()
	player.level = self
	
	var current_scene = "res://levels/margarita/margarita.tscn"
	pause_screen.current_scene = current_scene
	
	challenges.show()
	for x in challenges.get_children():
		x.targetscene = "res://levels/margarita/"+x.name+".tscn"
	
