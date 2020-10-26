extends Spatial

onready var pause_screen = get_node("../pause_screen")
onready var endscreen = get_node("../end_screen")

onready var goal_success_sound_clip = load("res://import/audio/action/goal_ring.wav")

var lap_count = GLOBAL.difficulty
var remaining_laps = GLOBAL.difficulty
onready var lap_label = find_node("lap_label")

onready var goals = get_node("Goals")
var current_goal_index = 0
var goal_list = [
	"goal_ring 1",
	"goal_ring 2",
	"goal_ring 3",
	"goal_ring 4",
	"goal_ring 5",
	"goal_ring 6",
	"goal_ring 7",
	"goal_ring 8",
	"goal_ring 9",
	"goal_ring 10",
	"goal_ring 11",
	"goal_ring 12",
	"goal_ring 13",
	"goal_ring 14",
	"goal_ring 15",
	"goal_ring 16",
	"goal_ring 17",
	"goal_ring 18",
	"goal_ring 19",
]

onready var level_timer: Timer = find_node("general_timer")
onready var level_timer_audioplayer = find_node("audioplayer_timer")

onready var player = get_node("../Spawn/Player")
onready var entities_container = get_node("Entities")

func _ready():
	player.level = self
	pause_screen.current_scene = "res://levels/speedrun/margarita.tscn"
	
	goals.show()
	for x in goals.get_children():
		x.hide()
		
	init_lap()
	
	
func init_speedrun():
	print("init_speedrun")
	level_timer.start()
	
func end_speedrun():
	print("end_speedrun")
	level_timer.stop()
	endscreen.start_endscreen({
		
	})	
		
func init_lap():
	lap_label.text = "Lap: " + str(lap_count - remaining_laps) + "/" + str(lap_count)
	var current_goal = goals.get_node(goal_list[current_goal_index])
	current_goal.show()
	current_goal.connect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")


func goal_hit():
	AUDIO_MANAGER.play_sfx(goal_success_sound_clip, 0)
	
	if	current_goal_index == 0 && lap_count == remaining_laps:
		print("pre_init_speedrun")
		init_speedrun()
		
	var current_goal = goals.get_node(goal_list[current_goal_index])
	current_goal.hide()
	current_goal.disconnect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")
	
	current_goal_index += 1
	
	if current_goal_index < len(goal_list):
		current_goal = goals.get_node(goal_list[current_goal_index])
		current_goal.show()
		current_goal.connect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")
	else:
		remaining_laps -= 1
		
		if	bool(remaining_laps):
			current_goal_index = 0
			init_lap()
		else:
			end_speedrun()
			
