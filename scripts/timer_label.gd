extends Label

var elapsedTime = 0

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
	
	var minutes = elapsedTime / 60
	var seconds = int(elapsedTime) % 60
	var mseconds = int(elapsedTime * 10) % 10
	var str_elapsed = "%02d : %02d : %02d" % [minutes, seconds, mseconds]
	
	text = "Time: "+str(str_elapsed)
