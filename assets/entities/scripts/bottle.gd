extends Spatial

signal add_item_to_player
var entity_name = "bottle"

func _ready():
	for node in get_tree().get_nodes_in_group("current_level"):
		var _connected_signal = connect("add_item_to_player", node, "_add_item_to_player")

#func _physics_process(delta):
#	pass
	
func _on_Area_body_entered(body):
	if	body.name == "KineBody":
		emit_signal("add_item_to_player", entity_name)
		queue_free()
		
