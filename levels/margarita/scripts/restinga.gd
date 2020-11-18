extends Spatial

onready var pause_screen = get_node("../pause_screen")
onready var endscreen = get_node("../end_screen")

onready var enter_water_sound_clip = load("res://import/audio/collision/splash2.wav")
onready var exit_water_sound_clip = load("res://import/audio/collision/splash1.wav")

onready var snail_sound_clip = load("res://import/audio/action/appear-online.wav")
onready var starfish_sound_clip = load("res://import/audio/action/bird_poo.wav")
onready var letter_sound_clip = load("res://import/audio/action/pageturn1.wav")

onready var bg_music = load("res://import/audio/background/At the Market.wav")

var MAX_TIME = 120.0
var MIN_STARFISH = 1
var MIN_SNAIL = 1
onready var goals = get_node("Goals")

onready var foreground_animations = find_node("foreground_animations")

onready var title_popup_label = find_node("title_popup_label")

onready var starfish_label = get_node("Foreground/margin/main_grid/counters_grid/item_list/starfish/starfish_value")
var starfish_count = 0
onready var snail_label = get_node("Foreground/margin/main_grid/counters_grid/item_list/snail/snail_value")
var snail_count = 0
onready var letter_label = get_node("Foreground/margin/main_grid/counters_grid/item_list/letter/letter_value")
var letter_count = 0

onready var level_timer = find_node("timer_label")
onready var level_timer_stopwatch: Timer = level_timer.get_node("general_timer")

onready var water_area = get_node("Terrain/water_area")

onready var player = get_node("../Spawn/Player")
onready var player_kine_body = get_node("../Spawn/Player/KineBody")
onready var player_camera = get_node("../Spawn/Player/KineBody/ClippedCamera")
onready var sun_light = get_node("../Environment/Sun")
onready var environment = load("res://assets/environments/env_swamp.tres")
onready var animationPlayer = get_node("../AnimationPlayer")

func _ready():
	player_camera.environment = environment
	player_camera.environment.background_sky.sun_latitude = sun_light.rotation_degrees.x * -1
	player_camera.environment.background_sky.sun_longitude = -180 - sun_light.rotation_degrees.y
	
	AUDIO_MANAGER.play_music(bg_music, -5)
	AUDIO_MANAGER.set_regular_button_sfx()
	player.level = self
	
	player.show_health()
	
	var current_scene = "res://levels/margarita/restinga.tscn"
	pause_screen.current_scene = current_scene
	endscreen.current_scene = current_scene
	endscreen.main_level = "margarita"
	
	if "letter" in GLOBAL.game_data.levels[endscreen.main_level].items_count.keys():
		if GLOBAL.game_data.levels[endscreen.main_level].items_count["letter"] > 0:
			goals.find_node("Letter").queue_free()
			letter_label.get_parent().queue_free()
		
	
	
#	for x in goals.get_children():
#		x.hide()
		
	init_speedrun()
	
func init_speedrun():
	print("init_speedrun")
	level_timer.goal = MAX_TIME
	level_timer_stopwatch.start()
	
func _on_Area_body_entered(body):
	print("cheking resources")
	if body.name == "KineBody":
		end_speedrun()
	
func _goal_reached():
	print("cheking resources")
	end_speedrun()
	
func game_over():
	print("level failed")
	end_speedrun()
	
func end_speedrun():
	player.hide_health()
	pause_screen.queue_free()
	get_node("Foreground").queue_free()
	
	var result_data : Dictionary = {}
	result_data.time = level_timer.elapsedTime
	result_data.level_name = "margarita/restinga"
	result_data.level_title = "Laguna de la Restinga"
	result_data.item_count = {
			"starfish": starfish_count,
			"snail": snail_count,
			"letter": letter_count,
	}
	
	var expected_data = {
		"max_time": MAX_TIME,
		"item_count": {
			"starfish": MIN_STARFISH,
			"snail": MIN_SNAIL,
			"letter": 1,
		},
	}
	
	endscreen.start_endscreen(expected_data,result_data)	
		
		
		
func _add_item_to_player(entity_name):
	if entity_name == "starfish":
		starfish_count += 1
		
		AUDIO_MANAGER.play_sfx(starfish_sound_clip, 0)
		foreground_animations.play("starfish_add")
		starfish_label.texture = load("res://import/2d/text_sprites/numbers/num_"+str(starfish_count)+".png")
	if entity_name == "snail":
		snail_count += 1
		
		AUDIO_MANAGER.play_sfx(snail_sound_clip, 0)
		foreground_animations.play("snail_add")
		snail_label.texture = load("res://import/2d/text_sprites/numbers/num_"+str(snail_count)+".png")
	if entity_name == "letter":
		letter_count += 1
		
		AUDIO_MANAGER.play_sfx(letter_sound_clip, 0)
		foreground_animations.play("letter_add")
		letter_label.texture = load("res://import/2d/text_sprites/numbers/num_"+str(letter_count)+".png")


func _on_water_area_body_entered(body):
	if body.name == "KineBody":
		AUDIO_MANAGER.play_sfx(enter_water_sound_clip, 0, -10)
		player.friction = 0.5
		player.enter_underwater()

func _on_water_area_body_exited(body):
	if body.name == "KineBody":
		AUDIO_MANAGER.play_sfx(exit_water_sound_clip, 0, -10)
		player.friction = 1
		player.exit_underwater()

func _player_damage_hit():
	print("_player_damage_hit")
	
#	print("_player_damage_hit")
	player.damage_hit = true
#	player.take_damage_hit()
