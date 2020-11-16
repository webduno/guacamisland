extends Control

onready var full_success_sound_clip = load("res://import/audio/result/Well Done CCBY3.wav")
onready var half_success_sound_clip = load("res://import/audio/result/solo-clap.wav")
onready var fail_sound_clip = load("res://import/audio/result/lose 1.wav")
onready var bg_music = load("res://import/audio/background/island_0.wav")

onready var congratulations = find_node("congratulations")
onready var try_again_button = find_node("try_again_button")
onready var next_button = find_node("next_button")

onready var time_label = find_node("time_value_label")
onready var level_label = find_node("level_value_label")
onready var item_list = get_node("margin/container/margin/results")
onready var item_template = get_node("margin/container/margin/results/level")


onready var animationPlayer = get_node("AnimationPlayer")
var main_level = ""
var current_scene

func _ready():
	hide()
	
func start_endscreen(expected_data, result_data):
	AUDIO_MANAGER.play_music(bg_music)
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var minutes = result_data.time / 60
	var seconds = int(result_data.time) % 60
	var mseconds = int(result_data.time * 10) % 10
	var str_elapsed = "%02d:%02d:%02d" % [minutes, seconds, mseconds]
	
#	result_data.level_name
	level_label.text = result_data.level_title
	time_label.text = str(str_elapsed)
	
	if result_data.level_name == "tutorial":
		AUDIO_MANAGER.play_sfx(full_success_sound_clip, 0)
		try_again_button.hide()
	else:
		for x in result_data.item_count.keys():
			print(x+":"+str(result_data.item_count[x])+"/"+str(expected_data.item_count[x] ))
			item_list.add_child(item_template.duplicate())
			
			var new_item = item_list.get_child(item_list.get_child_count()-1)
			new_item.get_node("level_Label").text = x+":"
			new_item.get_node("level_value_label").text = str(result_data.item_count[x])+"/"+str(expected_data.item_count[x])
			print(x+" -> "+str(result_data.item_count[x])+"/"+str(expected_data.item_count[x] ))
			
		if	result_data.time < expected_data.max_time:
			var losing = false
			
			for x in result_data.item_count.keys():
				if result_data.item_count[x] < expected_data.item_count[x]:
					losing = true
					lose(result_data)
					break
			if !losing:
				win(expected_data, result_data)
		else:
			lose(result_data)
		
	print("showing end screen")
	show()
	print("play animationPlayer")
	animationPlayer.play("Show")
	print("stop animationPlayer")
	
func win(expected_data, result_data):
	if main_level == "":
		GLOBAL.game_data.levels[result_data.level_name].certificate = true
	else:
		for x in result_data.item_count.keys():
#			if result_data.item_count[x] < expected_data.item_count[x]:
			if x in GLOBAL.game_data.levels[main_level].items_count.keys():
				GLOBAL.game_data.levels[main_level].items_count[x] += result_data.item_count[x] - expected_data.item_count[x]
			else:
				GLOBAL.game_data.levels[main_level].items_count[x] = result_data.item_count[x] - expected_data.item_count[x]
				
		
	AUDIO_MANAGER.play_sfx(full_success_sound_clip, 0)
	
	try_again_button.hide()
	var file = File.new()
	var error = file.open(GLOBAL.base_saves_path+GLOBAL.game_data.game_name+".dat", File.WRITE)
	if error == OK:
		file.store_var(GLOBAL.game_data)
		file.close()
		
func lose(_result_data):
	AUDIO_MANAGER.play_sfx(fail_sound_clip, 0)
	next_button.hide()
	congratulations.hide()

func _on_Button_Quit_Main_Menu_pressed():
	get_tree().paused = false
	return get_tree().change_scene("res://scenes/title_screen.tscn")

func _on_Button_Next_pressed():
	get_tree().paused = false
	return get_tree().change_scene("res://scenes/map_screen.tscn")

func _on_try_again_button_pressed():
	print("_on_try_again_button_pressed")
	get_tree().paused = false
	TRANSITION.change_scene(current_scene)
