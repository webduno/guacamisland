extends Label

var elapsedTime = 0
var goal = 2

signal goal_reached

onready var tick_sound_clip_1 = load("res://import/audio/ticks/ticking clock - tick1.wav")
onready var tick_sound_clip_2 = load("res://import/audio/ticks/ticking clock - tick2.wav")
func _ready():
	for node in get_tree().get_nodes_in_group("current_level"):
		var _connected_signal = connect("goal_reached", node, "_goal_reached")
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
	if elapsedTime >= goal:
		$general_timer.stop()	
		emit_signal("goal_reached")
	elapsedTime += .1;
	
	if str(elapsedTime).is_valid_integer():
		AUDIO_MANAGER.play_sfx(tick_sound_clip_1, 0, -15)
	
	var minutes = elapsedTime / 60
	var seconds = int(elapsedTime) % 60
	var mseconds = int(elapsedTime * 10) % 10
	var str_elapsed = "%02d:%02d:%02d" % [minutes, seconds, mseconds]
	
	text = "Time: "+str(str_elapsed)
