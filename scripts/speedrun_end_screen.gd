extends Control

onready var full_success_sound_clip = load("res://import/audio/result/Well Done CCBY3.wav")
onready var half_success_sound_clip = load("res://import/audio/result/solo-clap.wav")
onready var fail_sound_clip = load("res://import/audio/result/lose 1.wav")
onready var bg_music = load("res://import/audio/background/island_0.wav")

onready var congratulations = find_node("Laps_Label")
onready var try_again_button = find_node("Laps_Label")

onready var laps_label = find_node("Laps_Label")
onready var time_label = find_node("Time_Label")
onready var level_label = find_node("Level_Label")

func _ready():
	hide()
	pass # Replace with function body.
	
func start_endscreen(expected_data, result_data):
	AUDIO_MANAGER.play_music(bg_music)
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var minutes = result_data.time / 60
	var seconds = int(result_data.time) % 60
	var mseconds = int(result_data.time * 10) % 10
	var str_elapsed = "%02d:%02d:%02d" % [minutes, seconds, mseconds]
	
	level_label.text = str(result_data.level_name)
	laps_label.text = str(result_data.laps)
	time_label.text = str(str_elapsed)
	
	if	result_data.time <= expected_data.max_time:
		AUDIO_MANAGER.play_sfx(full_success_sound_clip, 0)
	else:
		AUDIO_MANAGER.play_sfx(fail_sound_clip, 0)
		
	show()

func _on_Button_Quit_Main_Menu_pressed():
	get_tree().paused = false
	return get_tree().change_scene("res://scenes/title_screen.tscn")


func _on_Button_Next_pressed():
	get_tree().paused = false
	return get_tree().change_scene("res://scenes/title_screen.tscn")
