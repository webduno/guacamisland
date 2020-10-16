extends Label


# Declare member variables here. Examples:
var elapsedTime = 0
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func asd():
	
	var frames: float = Engine.get_frames_per_second()
	text = "FPS: "
	text += str(frames)
	
	if frames >= 55:
		add_color_override("font_color", Color(0, 1, 0.1, 1))
	elif frames <= 25:
		add_color_override("font_color", Color(1, 0, 0, 1))
	else:
		add_color_override("font_color", Color(1, 1, 0, 1))
		


func _on_Timer_timeout():
	elapsedTime += .1;
	
	text = ""+str(elapsedTime)
