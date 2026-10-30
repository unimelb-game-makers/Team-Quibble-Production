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
	
	for action in InputMap.get_actions():
		if not action.begins_with("ui_") and not action.begins_with("hide_"):
			var entry = load_dict[action]
			if entry[0] == "k":
				var new_event: InputEventKey = InputEventKey.new()
				new_event.physical_keycode = entry[1]
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action, new_event)
			else:
				var new_event: InputEventMouseButton = InputEventMouseButton.new()
				new_event.button_index = entry[1]
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action, new_event)
				


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
			var events: Array[InputEvent] = InputMap.action_get_events(action)
			var event: InputEvent = events.front()
			if event is InputEventKey:
				save_dict[action] = ["k",event.physical_keycode]
			if event is InputEventMouseButton:
				save_dict[action] = ["m", event.button_index]
			
	return save_dict
