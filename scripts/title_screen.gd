extends Control

onready var input_change = load("res://import/audio/ticks/ticking clock - tick4.wav")

export (PackedScene) var savedgame_row = load("res://scenes/savedgame_row.tscn")


var base_path = "user://"
var base_saves_path = "user://saves/"
var gamelist = []

onready var buttons_animation = get_node("container/panel 1/buttons_animation")
onready var gamelist_panel = get_node("container/panel 2/gamelist_panel")
onready var gamelist_list = find_node("gamelist_list")
onready var gamelist_animation = gamelist_panel.get_node("margin/gamelist_animation")

onready var newgame_name_input = find_node("newgame_name_input")

var gametype = "speedrun"
var world = "margarita"

var difficulty = 1
onready var label_difficulty = find_node("label_difficulty")

func _ready():
	read_gamelist()
	AUDIO_MANAGER.set_regular_button_sfx()
	gamelist_panel.hide()
	buttons_animation.play("Fade_In")
	
func read_gamelist():
	var dir = Directory.new()
	if !dir.dir_exists(base_saves_path):
		dir.make_dir(base_saves_path)
		
	dir.open(base_saves_path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			print(file.get_basename())
			gamelist.append(file)

	dir.list_dir_end()
	fill_gamelist_list()
#	var file = File.new()
#	if file.file_exists(base_path+"gamelist.dat"):
#		print("reading gamelist...")
#		var error = file.open(base_path+"gamelist.dat", File.READ)
#		if error == OK:
#			gamelist = file.get_var()
#			print(gamelist)
#			file.close()
#			fill_gamelist_list()
#	else:
#		print("gamelist doesn't exist, creating file...")
#		var error = file.open(base_path+"gamelist.dat", File.WRITE)
#		if error == OK:
#			file.store_var(gamelist)
#			file.close()
			
func fill_gamelist_list():	
	for x in gamelist:
		var a = savedgame_row.instance()
		gamelist_list.add_child(a)
		
func _on_newgame_open_button_pressed():
	gamelist_panel.show()
	gamelist_animation.play("Gamelist_SlideIn")
	newgame_name_input.grab_focus()
	newgame_name_input.select_all()
	
func _on_save_newgame_button_pressed():
	var dir = Directory.new()
	if !dir.dir_exists(base_saves_path):
		dir.make_dir(base_saves_path)
	
	var file = File.new()
	var data = {
		"game_name": newgame_name_input.text,
	}
	var error = file.open(base_saves_path+newgame_name_input.text+".dat", File.WRITE)
	print("saving new game ("+base_saves_path+newgame_name_input.text+".dat)...")
	if error == OK:
		file.store_var(data)
		file.close()
		print("saved game.")
	
func _on_loadgame_open_button_pressed():
	gamelist_panel.show()
	gamelist_animation.play("Gamelist_SlideIn")
	
func _on_Button_Close_pressed(): gamelist_panel.hide()

func _on_tutorial_button_pressed():	return get_tree().change_scene("res://scenes/tutorial.tscn")

func _on_exit_button_pressed():	return get_tree().quit()





