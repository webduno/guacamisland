extends Control

onready var full_success_sound_clip = load("res://import/audio/result/Well Done CCBY3.wav")
onready var half_success_sound_clip = load("res://import/audio/result/solo-clap.wav")

onready var endscreen_audio_loop = get_node("endscreen_audio_loop")

onready var laps_label = find_node("Laps_Label")
onready var time_label = find_node("Time_Label")
onready var level_label = find_node("Level_Label")

func _ready():
	hide()
	pass # Replace with function body.
	
func start_endscreen(result_data):
	AUDIO_MANAGER.play_sfx(full_success_sound_clip, 0)
	endscreen_audio_loop.play()
	show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print(result_data)
	
	var minutes = result_data.time / 60
	var seconds = int(result_data.time) % 60
	var mseconds = int(result_data.time * 10) % 10
	var str_elapsed = "%02d:%02d:%02d" % [minutes, seconds, mseconds]
	
	level_label.text = str(result_data.level_name)
	laps_label.text = str(result_data.laps)
	time_label.text = str(str_elapsed)


func _on_Button_Quit_Main_Menu_pressed():
	get_tree().paused = false
	return get_tree().change_scene("res://scenes/title_screen.tscn")


func _on_Button_Next_pressed():
	get_tree().paused = false
	return get_tree().change_scene("res://scenes/title_screen.tscn")
