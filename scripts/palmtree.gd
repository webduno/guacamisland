extends Area

signal fire_coconut

var ready_to_shoot = true
var coconut_spawner_origin

# Called when the node enters the scene tree for the first time.
func _ready():
	coconut_spawner_origin = get_node("coconut_spawner").global_transform
	
	for node in get_tree().get_nodes_in_group("current_level"):
		connect("fire_coconut", node, "_fire_coconut")

func _on_palmtree_body_entered(body):
	if body.name == "tree_trunk":
		return
		
	emit_signal("fire_coconut", coconut_spawner_origin)
