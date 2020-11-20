extends Node

onready var game_name_label = get_node("margin/grid/game_info/game_name_label")
onready var index_selector = get_node("margin/grid/index_selector")

var game_data

func _on_Button_pressed():
	for node in get_tree().get_nodes_in_group("current_level"):
		node._savedgame_row_mouse_clicked(self)

func _on_Button_mouse_entered():
	for node in get_tree().get_nodes_in_group("current_level"):
		node._savedgame_row_mouse_entered(self)

func _on_Button_mouse_exited():
	for node in get_tree().get_nodes_in_group("current_level"):
		node._savedgame_row_mouse_exited(self)
