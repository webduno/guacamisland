extends Area

signal fire_coconut

var ready_to_shoot = false
var coconut_spawner_origin
onready var timer = get_node("coconut_timer")
onready var ready_to_shoot_coconut = get_node("ready_to_shoot_coconut")


# Called when the node enters the scene tree for the first time.
func _ready():
	coconut_spawner_origin = get_node("coconut_spawner").global_transform
	ready_to_shoot_coconut.hide()
	
	for node in get_tree().get_nodes_in_group("current_level"):
		connect("fire_coconut", node, "_fire_coconut")

func _on_palmtree_body_entered(body):
	if body.name == "tree_trunk":
		return
	
	if	ready_to_shoot:	
		emit_signal("fire_coconut", coconut_spawner_origin)
		timer.stop()
		timer.start()
		ready_to_shoot_coconut.hide()
		ready_to_shoot = false
	


func _on_coconut_timer_timeout():
	ready_to_shoot = true
	ready_to_shoot_coconut.show()
	pass # Replace with function body.
