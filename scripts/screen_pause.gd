extends Control

var current_scene;

onready var pause_sound_clip = load("res://import/audio/action/message.wav")

func _ready():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if	!get_tree().paused:
			show()
			pause()
		else:
			hide()
			unpause()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_button_resume_pressed():
	hide()
	unpause()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_button_reset_level_pressed():
	unpause()
	return get_tree().change_scene(current_scene)

func _on_button_quit_to_menu_pressed():
	unpause()
	return get_tree().change_scene(GLOBAL.title_screen)

func pause():
	print("pausing")
	get_tree().paused = true
	AUDIO_MANAGER.play_sfx(pause_sound_clip, 0)
	AUDIO_MANAGER.pause_music()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass
func unpause():
	get_tree().paused = false
	AUDIO_MANAGER.unpause_music()
	pass
