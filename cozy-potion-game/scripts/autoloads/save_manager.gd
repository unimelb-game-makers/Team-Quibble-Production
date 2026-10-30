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
	var loaded_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var load_dict: Dictionary
	if loaded_file:
		var res = JSON.parse_string(loaded_file.get_line())
		if res:
			load_dict = res
		else:
			return
	else:
		return
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
	
	PersistentInventory.pantry.assign(load_dict["pantry"].map(deserialize_stack))
	PersistentInventory.money = load_dict["money"]
	#no fucking clue why -1 needed
	TimeCycle.days_passed = load_dict["day"] - 1


func generate_save_dict() -> Dictionary[String, Variant]:
	var save_dict: Dictionary[String, Variant]
	save_dict["pantry"] = PersistentInventory.pantry.map(serialize_stack)
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

func serialize_stack(stack: Stack) -> Array:
		var ingredient_id: Alchemy.IngredientID = stack.item.ingredient_id
		var process_id: Alchemy.ProcessID = stack.item.process_applied.front() if stack.item.process_applied.front() else -1
		return [stack.quantity, ingredient_id, process_id]

func deserialize_stack(array: Array) -> Stack:
	var item: PotionIngredient = Alchemy.find_ingredient_by_id(array[1])
	if array[2] >= 0:
		item.apply_process(array[2])
	return Stack.new(array[0], item)
