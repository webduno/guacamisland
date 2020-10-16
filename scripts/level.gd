extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pause_menu = get_node("pause_menu")


# Called when there is an input event
# func _input(event: InputEvent) -> void:
		
			
			
	# get_tree().quit() # Quits the game
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if	!get_tree().paused:
			pause_menu.show()
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			pause_menu.hide()
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_button_pressed():
	pause_menu.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_quit_button_pressed():
	get_tree().quit() # Quits the game
