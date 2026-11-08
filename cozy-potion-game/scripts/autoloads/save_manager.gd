extends Node

const SAVE_PATH = "user://alchemimi.save"

var restoring_session: bool = false
var saved_session: Dictionary = {}
var saved_scene_path: String = ""
var saved_player_transform: Dictionary = {}
var saved_foraging_bag: Array = []

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
	TimeCycle.days_passed = int(load_dict["day"])
	TimeCycle.day_progress = float(load_dict.get("day_progress", 0.0))
	TimeCycle.target_day_progress = float(load_dict.get("target_day_progress", TimeCycle.day_progress))
	TimeCycle.customers_per_day = int(load_dict.get("customers_per_day", 6))
	
	if load_dict.has("customer_queue"):
		deserialize_customers(load_dict["customer_queue"])
	
	TutorialDirector.tutorial_day = load_dict.get(
	"tutorial_day",
	load_dict["day"] <= 2
	)

	TutorialDirector.portal_open = load_dict.get(
		"portal_open",
		load_dict["day"] >= 2
	)

	TimeCycle.visited_forest_this_day = false
	restoring_session = true
	saved_scene_path = str(load_dict.get("current_scene", ""))
	saved_player_transform = load_dict.get("player_transform", {})
	saved_foraging_bag = load_dict.get("foraging_bag", [])
	PersistentInventory.hotbar_data = load_dict.get("hotbar", [])


func generate_save_dict() -> Dictionary[String, Variant]:
	var save_dict: Dictionary[String, Variant]
	var active_scene = SceneManager.sub_viewport.get_child(0)
	save_dict["pantry"] = PersistentInventory.pantry.map(serialize_stack)
	save_dict["money"] = PersistentInventory.money
	save_dict["day"] = TimeCycle.days_passed
	save_dict["customer_queue"] = serialize_customers()
	save_dict["tutorial_day"] = TutorialDirector.tutorial_day
	save_dict["day_progress"] = TimeCycle.day_progress
	save_dict["target_day_progress"] = TimeCycle.target_day_progress
	save_dict["customers_per_day"] = TimeCycle.customers_per_day
	save_dict["portal_open"] = TutorialDirector.portal_open
	save_dict["player_state"] = capture_player_state()
	save_dict["current_scene"] = active_scene.scene_file_path
	
	save_dict["master_volume"] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Master"))
	print_debug("saved master volume of %s" % save_dict["master_volume"])
	save_dict["sfx_volume"] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Sfx"))
	save_dict["ambience_volume"] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Ambience"))

	var player = get_tree().get_first_node_in_group("player")

	if player:
		save_dict["player_transform"] = {
			"position": [
				player.global_position.x,
				player.global_position.y,
				player.global_position.z
			],
			"rotation": [
				player.rotation.x,
				player.rotation.y,
				player.rotation.z
			]
		}

	if player and player is WorldPlayer and player.hotbar_display:
		PersistentInventory.hotbar_data = (
			player.hotbar_display.inventory.export_stacks().map(serialize_stack)
		)

	save_dict["hotbar"] = PersistentInventory.hotbar_data

	var bag = get_tree().get_first_node_in_group("foraging_bag")

	if bag:
		save_dict["foraging_bag"] = bag.hover_inventory.inventory.export_stacks().map(serialize_stack)
	else:
		save_dict["foraging_bag"] = []

	for action in InputMap.get_actions():
		if not action.begins_with("ui_") and not action.begins_with("hide_"):
			var events: Array[InputEvent] = InputMap.action_get_events(action)
			var event: InputEvent = events.front()
			if event is InputEventKey:
				save_dict[action] = ["k",event.physical_keycode]
			if event is InputEventMouseButton:
				save_dict[action] = ["m", event.button_index]
			
	return save_dict
	
func capture_player_state() -> Dictionary:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return {}

	return {
		"position": [
			player.global_position.x,
			player.global_position.y,
			player.global_position.z
		],
		"rotation": [
			player.rotation.x,
			player.rotation.y,
			player.rotation.z
		]
	}

func serialize_stack(stack: Stack) -> Array:
	if stack == null or stack.item == null:
		return []

	if stack.item is PotionIngredient:
		var ingredient: PotionIngredient = stack.item
		var process_id: int = -1

		if not ingredient.process_applied.is_empty():
			process_id = ingredient.process_applied.front()

		return [
			stack.quantity,
			ingredient.ingredient_id,
			process_id
		]

	if stack.item is Potion:
		var potion: Potion = stack.item

		return [
			stack.quantity,
			"potion",
			potion.potion_id,
			potion.potion_primary,
			potion.potion_secondary,
			potion.potion_attribute_strength,
			potion.base_gold_value,
			potion.potion_name
		]

	return []

func deserialize_stack(data: Array) -> Stack:
	if data.is_empty():
		return Stack.new()

	if data.size() >= 8 and data[1] == "potion":
		var potion := Potion.new()

		potion.potion_id = int(data[2])
		potion.potion_primary = int(data[3])
		potion.potion_secondary = int(data[4])
		potion.potion_attribute_strength = int(data[5])
		potion.base_gold_value = int(data[6])
		potion.potion_name = str(data[7])

		if potion.has_method("create_potion_sprite"):
			potion.create_potion_sprite()

		return Stack.new(int(data[0]), potion)

	var ingredient: PotionIngredient = Alchemy.find_ingredient_by_id(int(data[1])).copy()

	if int(data[2]) >= 0:
		ingredient.apply_process(int(data[2]))

	return Stack.new(int(data[0]), ingredient)

func serialize_customers() -> Array:
	var result: Array = []

	for customer in CustomerManager.customer_queue:
		result.append({
			"customer_id": int(customer.customer_id),
			"needs": Array(customer.needs),
			"need_severities": Array(customer.need_severities),
			"time_allotment": customer.time_allotment
		})

	return result

func deserialize_customers(data: Array) -> void:
	CustomerManager.customer_queue.clear()

	for entry in data:
		var customer := Customer.new()

		customer.customer_id = int(entry["customer_id"]) as Customer.CustomerID

		for need in entry["needs"]:
			customer.needs.append(int(need) as Alchemy.NeedID)

		for severity in entry["need_severities"]:
			customer.need_severities.append(float(severity))

		customer.time_allotment = float(entry["time_allotment"])

		CustomerManager.customer_queue.append(customer)

func restore_scene_state() -> void:
	var player = get_tree().get_first_node_in_group("player")

	if player and not saved_player_transform.is_empty():
		var pos = saved_player_transform["position"]
		var rot = saved_player_transform["rotation"]

		player.global_position = Vector3(pos[0], pos[1], pos[2])
		player.rotation = Vector3(rot[0], rot[1], rot[2])

	var bag = get_tree().get_first_node_in_group("foraging_bag")

	if bag:
		for data in saved_foraging_bag:
			var stack = deserialize_stack(data)

			if not stack.isEmpty:
				bag.hover_inventory.inventory.blind_add_stack(stack)

	DayStarter.fired = true
	restoring_session = false

func continue_saved_game() -> void:
	var scene_path = saved_scene_path

	if scene_path.is_empty():
		push_error("No saved scene path found.")
		restoring_session = false
		return

	Portal.spawn_at_portal = false

	var loaded = await SceneManager.change_active_scene_to_file(
		scene_path,
		SceneManager.TRANSITIONS.FADE
	)

	if not loaded:
		restoring_session = false
		return

	await get_tree().process_frame
	restore_scene_state()
