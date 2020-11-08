extends Spatial

var targetscene

func _ready():
	pass # Replace with function body.

func _on_Area_body_entered(body):
	if body.name == "KineBody":
		TRANSITION.change_scene(targetscene)
	else:
		print(body.name)
