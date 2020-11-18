extends Spatial

signal add_item_to_player
signal player_damage_hit
var entity_name = "letter"
var is_entity_shell_broken = false
onready var shell_object = get_node("bottle/bottle2")
onready var shell_object_2 = get_node("bottle/cap2")

var sfx_bottlebreak = load("res://import/audio/collision/Bottle Break.wav")

func _ready():
	for node in get_tree().get_nodes_in_group("current_level"):
		var _connected_signal = connect("add_item_to_player", node, "_add_item_to_player")
		_connected_signal = connect("player_damage_hit", node, "_player_damage_hit")

#func _physics_process(delta):
#	pass

	
func _on_Area_body_entered(body):
	if	body.name == "KineBody":
		if shell_object.visible:
			shell_object.hide()
			shell_object_2.hide()
			AUDIO_MANAGER.play_sfx(sfx_bottlebreak, 0, -10)
			emit_signal("player_damage_hit")
		else:
			emit_signal("add_item_to_player", entity_name)
			queue_free()
		
