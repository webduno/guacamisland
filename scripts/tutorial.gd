extends Spatial

onready var goal_success_sound_clip = load("res://import/audio/action/goal_ring.wav")
onready var lap_complete_sound_clip = load("res://import/audio/action/lap_complete.wav")
onready var bg_music = load("res://import/audio/background/jump and run - tropics.wav")

onready var pause_screen = get_node("../pause_screen")
onready var endscreen = get_node("../end_screen")

onready var goals = get_node("Goals")
var current_goal_index = 0
var goal_list = ["goal_ring 0",#	"goal_ring 1",
	"goal_ring 2","goal_ring 3","goal_ring 4","goal_ring 5",
	"goal_ring 6","goal_ring 7","goal_ring 8","goal_ring 9",
	"goal_ring 10","goal_ring 11",
]

var lap_count = 2
var remaining_laps = 2
onready var lap_label = find_node("lap_label")
onready var lap_popup_label = find_node("lap_popup_label")
onready var lap_popup_animation = find_node("lap_popup_animation")

onready var level_timer = find_node("timer_label")
onready var level_timer_stopwatch: Timer = level_timer.get_node("general_timer")
onready var level_timer_audioplayer = level_timer.get_node("audioplayer_timer")

onready var player = get_node("../Spawn/Player")
onready var entities_container = get_node("Entities")

func _ready():
	AUDIO_MANAGER.set_regular_button_sfx()
	AUDIO_MANAGER.play_music(bg_music, -15)
	player.level = self
	player.walk_enabled = false
	
	var current_scene = "res://scenes/tutorial.tscn"
	pause_screen.current_scene = current_scene
	endscreen.current_scene = current_scene
	
	goals.show()
	for x in goals.get_children():
		x.hide()
		if x.has_node("Help"):
			x.get_node("Help").hide()
		
	init_lap()
	
	
func init_speedrun():
	print("init_speedrun")
	level_timer_stopwatch.start()
	
func end_speedrun():
	pause_screen.queue_free()
	get_node("Foreground").queue_free()
	
	var result_data : Dictionary = {}
	result_data.level_name = "tutorial"
	result_data.level_title = "Tutorial"
	result_data.laps = lap_count
	result_data.time = level_timer.elapsedTime
	
	endscreen.start_endscreen({
		"max_time": 9999999999.0
	},result_data)	
		
		
func init_lap():
	lap_label.text = "Lap: " + str(lap_count - remaining_laps) + "/" + str(lap_count)
	
	if	remaining_laps < lap_count:
		AUDIO_MANAGER.play_sfx(lap_complete_sound_clip, 0)
		lap_popup_label.text = "Lap: " + str(lap_count - remaining_laps) + "/" + str(lap_count)
		lap_popup_animation.play("Fade Out")
		
	show_goal(current_goal_index)

func show_goal(goal_index):
	var current_goal = goals.get_node(goal_list[goal_index])
	current_goal.show()
	print(current_goal.name)
	if current_goal.has_node("Help") and remaining_laps == lap_count:
		current_goal.get_node("Help").show()
	current_goal.connect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")
	
func hide_goal(goal_index):
	if	goal_index == 0:
		player.walk_enabled = true
		
	var current_goal = goals.get_node(goal_list[goal_index])
	current_goal.hide()
	if current_goal.has_node("Help"):
		current_goal.get_node("Help").hide()
	current_goal.disconnect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")

func goal_hit():
	AUDIO_MANAGER.play_sfx(goal_success_sound_clip, 0)
	
	if	current_goal_index == 0 && lap_count == remaining_laps:
		print("pre_init_speedrun")
		init_speedrun()
		
	hide_goal(current_goal_index)
	
	current_goal_index += 1
	
	if current_goal_index < len(goal_list):
		show_goal(current_goal_index)
	else:
		remaining_laps -= 1
		
		if	bool(remaining_laps):
			current_goal_index = 0
			init_lap()
		else:
			end_speedrun()
