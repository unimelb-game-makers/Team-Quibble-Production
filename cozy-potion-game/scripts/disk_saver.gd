class_name DiskSaver
extends Node


# Saves data to Disk as JSON, intended to only be used with in this script
static func _save_to_disk(data: Variant, save_path : String) -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	if file:
		var json = JSON.stringify(data)
		file.store_string(json)

# Loads data to Disk from JSON, intended to only be used with in this script
static func _load_from_disk(save_path : String) -> Array:
	if not FileAccess.file_exists(save_path):
		print("file does not exist")
		return []
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	if not file:
		print("file failed to open")
		return []
	
	return JSON.parse_string(file.get_as_text())


# Used to save dictionary of stacks as JSON file
static func save_stack_dict_to_disk(data: Dictionary[String, Stack], \
	save_path: String) -> void:
	
	var json_array : Array[Dictionary]
	for key in data.keys():
		var stack_dict = convert_stack_to_dict(data[key])
		stack_dict["key"] = key
		json_array.append(stack_dict)

	_save_to_disk(json_array, save_path)


# Used to load dictionary of stacks from JSON file
static func load_stack_dict_from_disk(save_path : String) \
		-> Dictionary[String, Stack]:
	var data : Array = _load_from_disk(save_path)
	var new_dict : Dictionary[String, Stack] = {}

	for item in data:
		new_dict[item["key"]] = convert_dict_to_stack(item)
	return new_dict


# Used to save Array of Stacks to JSON file
static func save_stack_arr_to_disk(data: Array[Stack], save_path: String) \
		-> void:
	
	var json_array : Array[Dictionary]
	for i in range(data.size()):
		json_array.append(convert_stack_to_dict(data[i]))
	
	_save_to_disk(json_array, save_path)

# Used to load Array of Stacks from JSON file
static func load_stack_arr_from_disk(save_path : String) -> Array[Stack]:
	var data : Array = _load_from_disk(save_path)
	var new_arr : Array[Stack] = []

	for item in data:
		new_arr.append(convert_dict_to_stack(item))
	return new_arr


# Converts stack prop to dict for saving as JSON file
static func convert_stack_to_dict(stack: Stack) -> Dictionary:
	return {
		"name" : stack.item_name,
		"quantity" : str(stack.quantity),
	}


# Converts stack dict to a Stack
static func convert_dict_to_stack(dict : Dictionary) -> Stack:
	return Stack.new(int(dict["quantity"]), dict["name"])
