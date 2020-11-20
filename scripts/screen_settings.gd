extends Control

onready var bg_music = load("res://import/audio/background/story time.wav")
onready var input_change = load("res://import/audio/ticks/ticking clock - tick4.wav")
onready var button_hover = load("res://import/audio/interface/Menu Selection Click.wav")

export (PackedScene) var savedgame_row = load("res://scenes/partials/savedgame_row.tscn")


var gamelist = []

onready var sound_volume_label = get_node("container/panel 1/grid/settings_grid/sound_volume_row/sound_volume_label")
onready var sound_volume_value = get_node("container/panel 1/grid/settings_grid/sound_volume_row/sound_volume_value")
onready var sfx_volume_label = get_node("container/panel 1/grid/settings_grid/sfx_volume_row/sfx_volume_label")
onready var sfx_volume_value = get_node("container/panel 1/grid/settings_grid/sfx_volume_row/sfx_volume_value")

onready var buttons_animation = get_node("container/panel 1/buttons_animation")

onready var newgame_name_input = find_node("newgame_name_input")

var gametype = "speedrun"
var world = "margarita"

var difficulty = 1
onready var label_difficulty = find_node("label_difficulty")

func _ready():
	pass
#	updateOrCreateSettingsFile()
	
func updateOrCreateSettingsFile():
	print("updateOrCreateSettingsFile")
	var file2Check = File.new()
	var doFileExists = file2Check.file_exists(GLOBAL.base_path+"settings.dat")
	
	if doFileExists:
		var fileData = File.new()
		var error = fileData.open(GLOBAL.base_path+"settings.dat", File.READ)
		if error == OK:
			var data = fileData.get_var()
			GLOBAL.settings = data
	else:
		var file = File.new()
		var data = {
			"sound_volume": 0,
			"sfx_volume": 0,
		}
		var error = file.open(GLOBAL.base_path+"settings.dat", File.WRITE)
		print("saving new settings file...")
		if error == OK:
			file.store_var(data)
			file.close()
			print("saved settings.")
			GLOBAL.settings = data
	
	print("loaded:")
	print(GLOBAL.settings)
	
func start_settings_screen():
	print("start_settings_screen")
	fix_settings_values()
	show()
	
func fix_settings_values():
	print("fix_settings_values")
	updateOrCreateSettingsFile()
	var current_volume = GLOBAL.settings["sound_volume"]
	AUDIO_MANAGER.change_volume(current_volume)
	sound_volume_label.text= "Sound Volume (Dcb Gain): "+str(current_volume)	
	var current_ssfx_volume = GLOBAL.settings["sfx_volume"]
	sfx_volume_label.text= "Sound Volume (Dcb Gain): "+str(current_ssfx_volume)	
	
	
func _on_dont_save_button_pressed():
	hide()
func _on_save_button_pressed():
	print("saving:")
	print(GLOBAL.settings)
	var file = File.new()
	var data = GLOBAL.settings
	var error = file.open(GLOBAL.base_path+"settings.dat", File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()
		print("saved settings.")
	hide()

func _on_sound_volume_value_value_changed(value):
	print("changed to"+str(value))
	sound_volume_label.text = "Sound Volume (Dcb Gain): "+str(value)	
#	var current_volume = GLOBAL.settings.sound_volume
	var new_volume = value
	GLOBAL.settings.sound_volume = new_volume
	AUDIO_MANAGER.change_volume(new_volume)


func _on_sfx_volume_value_value_changed(value):
	print("changed to"+str(value))
	sfx_volume_label.text = "Sfx Volume (Dcb Gain): "+str(value)	
#	var current_volume = GLOBAL.settings.sfx_volume
	var new_volume = value
	GLOBAL.settings.sfx_volume = new_volume
	AUDIO_MANAGER.change_sfx_volume(new_volume)

func __ready():
	read_gamelist()
	AUDIO_MANAGER.set_regular_button_sfx()
	AUDIO_MANAGER.play_music(bg_music, -15)
	buttons_animation.play("Fade_In")
	
func read_gamelist():
	var dir = Directory.new()
	if !dir.dir_exists(GLOBAL.base_saves_path):
		dir.make_dir(GLOBAL.base_saves_path)
		
	dir.open(GLOBAL.base_saves_path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			var fileData = File.new()
			var error = fileData.open(GLOBAL.base_saves_path+file, File.READ)
			if error == OK:
				var data = fileData.get_var()
				var modified = fileData.get_modified_time(fileData.get_path())
				modified = OS.get_datetime_from_unix_time(modified + OS.get_time_zone_info().bias * 60)
				var last_modified = "%02d/%02d/%02d" % [modified.year, modified.month, modified.day]
				last_modified += " - "
				last_modified += "%02d:%02d:%02d" % [modified.hour, modified.minute, modified.second]
				gamelist.append({
					"name": data.game_name,
					"last_modified": last_modified,
					"size": str(fileData.get_len())+" bytes",
					"data": data,
				})
#				gamelist.append(fileData.get_var())
				fileData.close()

	newgame_name_input.text = "New_Adventure_"+str(gamelist.size() + 1)

	dir.list_dir_end()
			
func _savedgame_row_mouse_entered(event):
	AUDIO_MANAGER.play_sfx(input_change, 0, -15)
	event.index_selector.show()
func _savedgame_row_mouse_exited(event):
	event.index_selector.hide()
func _savedgame_row_mouse_clicked(event):
	GLOBAL.game_data = event.game_data
	return get_tree().change_scene(GLOBAL.map_screen)
	
func _on_save_newgame_button_pressed():
	var dir = Directory.new()
	if !dir.dir_exists(GLOBAL.base_saves_path):
		dir.make_dir(GLOBAL.base_saves_path)
	
	var file = File.new()
	var data = {
		"game_name": newgame_name_input.text,
		"levels": {
			"margarita": {
				"certificate": false,
				"time": 0.0,
				"items_count": {},
				"sublevels": {},
			},
		},
	}
	var error = file.open(GLOBAL.base_saves_path+newgame_name_input.text+".dat", File.WRITE)
	print("saving new game ("+GLOBAL.base_saves_path+newgame_name_input.text+".dat)...")
	if error == OK:
		file.store_var(data)
		file.close()
		print("saved game.")
		
		GLOBAL.game_data = data
		return get_tree().change_scene(GLOBAL.map_screen)


