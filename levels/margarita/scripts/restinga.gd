extends Spatial

onready var pause_screen = get_node("../pause_screen")
onready var endscreen = get_node("../end_screen")

onready var enter_water_sound_clip = load("res://import/audio/collision/splash2.wav")
onready var exit_water_sound_clip = load("res://import/audio/collision/splash1.wav")

onready var goal_success_sound_clip = load("res://import/audio/action/goal_ring.wav")
onready var lap_complete_sound_clip = load("res://import/audio/action/lap_complete.wav")
onready var bg_music = load("res://import/audio/background/At the Market.wav")

var MAX_TIME = 3.0
onready var goals = get_node("Goals")

onready var foreground_animations = find_node("foreground_animations")

onready var title_popup_label = find_node("title_popup_label")

onready var starfish_label = get_node("Foreground/margin/main_grid/counters_grid/item_list/starfish/starfish_value")
var starfish_count = 0
onready var snail_label = get_node("Foreground/margin/main_grid/counters_grid/item_list/snail/snail_value")
var snail_count = 0

onready var level_timer = find_node("timer_label")
onready var level_timer_stopwatch: Timer = level_timer.get_node("general_timer")

onready var river_water_overlay = get_node("Foreground/river_water_overlay")
onready var water_area = get_node("Terrain/water_area")

onready var player = get_node("../Spawn/Player")
onready var player_kine_body = get_node("../Spawn/Player/KineBody")
onready var player_camera = get_node("../Spawn/Player/KineBody/ClippedCamera")
onready var sun_light = get_node("../Environment/Sun")
onready var environment = load("res://assets/environments/env_swamp.tres")

func _ready():
	player_camera.environment = environment
	player_camera.environment.background_sky.sun_latitude = sun_light.rotation_degrees.x * -1
	player_camera.environment.background_sky.sun_longitude = -180 - sun_light.rotation_degrees.y
	
	AUDIO_MANAGER.play_music(bg_music, -5)
	AUDIO_MANAGER.set_regular_button_sfx()
	player.level = self
	
	var current_scene = "res://levels/margarita/restinga.tscn"
	pause_screen.current_scene = current_scene
	endscreen.current_scene = current_scene
	
	goals.show()
#	for x in goals.get_children():
#		x.hide()
		
#	init_lap()
	
func init_speedrun():
	print("init_speedrun")
	level_timer_stopwatch.start()
	
func end_speedrun():
	pause_screen.queue_free()
	get_node("Foreground").queue_free()
	
	var result_data : Dictionary = {}
	result_data.laps = 0
	result_data.time = level_timer.elapsedTime
	result_data.level_name = "margarita"
	result_data.level_title = "Margarita Island"
	
	endscreen.start_endscreen({
		"max_time": MAX_TIME,
	},result_data)	
		
		
		
func _add_item_to_player(entity_name):
	if entity_name == "starfish":
		starfish_count += 1
		foreground_animations.play("starfish_add")
		starfish_label.texture = load("res://import/2d/text_sprites/numbers/num_"+str(starfish_count)+".png")
	if entity_name == "snail":
		snail_count += 1
		foreground_animations.play("snail_add")
		snail_label.texture = load("res://import/2d/text_sprites/numbers/num_"+str(snail_count)+".png")
	
##func init_lap():
##	lap_label.text = "Lap: " + str(lap_count - remaining_laps) + "/" + str(lap_count)
##
##	if	remaining_laps < lap_count:
##		AUDIO_MANAGER.play_sfx(lap_complete_sound_clip, 0)
##		lap_popup_label.text = "Lap: " + str(lap_count - remaining_laps) + "/" + str(lap_count)
##		lap_popup_animation.play("Fade Out")
##
##	show_goal(current_goal_index)
##
##func show_goal(goal_index):
##	var current_goal = goals.get_node(goal_list[goal_index])
##	current_goal.show()
##	print(current_goal.name)
##	if current_goal.has_node("Help") and remaining_laps == lap_count:
##		current_goal.get_node("Help").show()
##	current_goal.connect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")
##
##func hide_goal(goal_index):
##	if	goal_index == 0:
##		player.walk_enabled = true
##
##	var current_goal = goals.get_node(goal_list[goal_index])
##	current_goal.hide()
##	if current_goal.has_node("Help"):
##		current_goal.get_node("Help").hide()
##	current_goal.disconnect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")
#
#func goal_hit():
#	AUDIO_MANAGER.play_sfx(goal_success_sound_clip, 0)
#
#	if	current_goal_index == 0 && lap_count == remaining_laps:
#		print("pre_init_speedrun")
#		init_speedrun()
#
#	hide_goal(current_goal_index)
#
#	current_goal_index += 1
#
#	if current_goal_index < len(goal_list):
#		show_goal(current_goal_index)
#	else:
#		remaining_laps -= 1
#
#		if	bool(remaining_laps):
#			current_goal_index = 0
#			init_lap()
#		else:
#			end_speedrun()


func _on_water_area_body_entered(body):
	if body.name == "KineBody":
		AUDIO_MANAGER.play_sfx(enter_water_sound_clip, 0, -10)
		player.friction = 0.5
		river_water_overlay.show()

func _on_water_area_body_exited(body):
	if body.name == "KineBody":
		AUDIO_MANAGER.play_sfx(exit_water_sound_clip, 0, -10)
		player.friction = 1
		river_water_overlay.hide()
