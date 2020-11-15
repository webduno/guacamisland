extends Area

signal add_coconut_to_player

var initial_jump = 6
var velocity := Vector3(0,0,0)


func _ready():
	velocity.y = initial_jump
	
	for node in get_tree().get_nodes_in_group("current_level"):
		connect("add_coconut_to_player", node, "_add_coconut_to_player")

func _physics_process(delta):
	velocity.y -= gravity * delta 
	translate(velocity * delta)
	
func _on_Spatial_body_entered(body):
	print(body.name+" HIT ME!")
	if	body.name == "Player":
		emit_signal("add_coconut_to_player")
		
	queue_free()
