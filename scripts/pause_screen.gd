extends Control

var current_scene;

func _ready():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if	!get_tree().paused:
			show()
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			hide()
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_button_resume_pressed():
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_button_reset_level_pressed():
	get_tree().paused = false
	return get_tree().change_scene(current_scene)

func _on_button_quit_to_menu_pressed():
	get_tree().paused = false
	return get_tree().change_scene("res://scenes/title_screen.tscn")
	
func _on_button_quit_game_pressed():
	get_tree().quit()
