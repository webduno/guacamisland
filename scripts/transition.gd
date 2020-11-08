extends CanvasLayer

signal scene_changed()

onready var animation_player = get_node("AnimationPlayer")
onready var black = get_node("Control/ColorRect")

func change_scene(path, delay = 0):
	AUDIO_MANAGER.pause_music()
	get_tree().paused = true
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("Fade_In")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation_player.play_backwards("Fade_In")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")
	get_tree().paused = false
	AUDIO_MANAGER.unpause_music()
