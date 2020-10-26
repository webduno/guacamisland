extends Control

func _ready():
	pass # Replace with function body.
	
func start_endscreen(data):
	show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print(data)
