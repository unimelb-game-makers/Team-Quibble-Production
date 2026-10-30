extends Node

const SAVE_PATH = "user://alchemimi.save"

func save_game() -> void:
	print_debug("saved!")
	#DirAccess.make_dir_recursive_absolute(SAVE_PATH)
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not save_file: 
		print_debug("save failed with error %d" % FileAccess.get_open_error())
	var save_dict = generate_save_dict()
	save_file.store_string(JSON.stringify(save_dict))
	pass

func load_game() -> void:
	print_debug("loaded!")
	var load_dict = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if load_dict:
		load_dict = JSON.parse_string(load_dict.get_line())
	print_debug("read master volume of %s" % load_dict["master_volume"])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Master"), load_dict["master_volume"])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Sfx"), load_dict["sfx_volume"])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Ambience"), load_dict["ambience_volume"])
	pass


func generate_save_dict() -> Dictionary[String, Variant]:
	var save_dict: Dictionary[String, Variant]
	save_dict["pantry"] = PersistentInventory.pantry
	save_dict["money"] = PersistentInventory.money
	save_dict["day"] = TimeCycle.days_passed
	
	save_dict["master_volume"] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Master"))
	print_debug("saved master volume of %s" % save_dict["master_volume"])
	save_dict["sfx_volume"] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Sfx"))
	save_dict["ambience_volume"] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Ambience"))

	for action in InputMap.get_actions():
		if not action.begins_with("ui_") and not action.begins_with("hide_"):
			save_dict[action] = InputMap.action_get_events(action)
			
	return save_dict
