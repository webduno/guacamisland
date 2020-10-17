extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Button_New_Game_pressed():
	return get_tree().change_scene("res://scenes/tutorial_test.tscn")

func _on_Button_Tutorial_pressed():
	return get_tree().change_scene("res://scenes/tutorial_test.tscn")

func _on_Button_Exit_pressed():
	get_tree().quit() # Quits the game


