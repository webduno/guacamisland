extends Control

onready var border_panel = get_node("margin/border_panel")
onready var certificate_sound_clip = load("res://import/audio/action/pageturn1.wav")

var island_data

func _ready():
	$AnimationPlayer.play("Certificate_Appear")
	pass

func _on_Button_mouse_entered():
	for node in get_tree().get_nodes_in_group("current_level"):
		node.emit_signal("island_row_mouse_entered", self)

func _on_Button_mouse_exited():
	for node in get_tree().get_nodes_in_group("current_level"):
		node.emit_signal("island_row_mouse_exited", self)

func _on_Button_pressed():
	for node in get_tree().get_nodes_in_group("current_level"):
		node.emit_signal("island_row_play_clicked", self)

func _on_certificate_mouse_entered():
	AUDIO_MANAGER.play_sfx(certificate_sound_clip, 0)
