extends Node
# This is a ductape solution. A better solution will probably need to be implemented in the future

var popup_manager: PopupManager
var list_manager: ListManager

# project group names
const Group = {
	GROUP_PLAYER = "player",
	GROUP_INTERACTABLE_OBJECTS = "interactable_objects",
	GROUP_POPUP_SUBWINDOW = "popup_subwindow"
}

#takes a string path and returns the json file at that location
static func get_json(path: String) -> JSON:
	var json_string: String = FileAccess.open(path, FileAccess.READ).get_as_text()
	var json_data: JSON = JSON.new()

	var parse_result = json_data.parse(json_string)
	if parse_result != OK:
		print_debug("Variable json_data was null. %s" % [json_data.get_error_message()])
		return null
	return json_data

#takes an array(hopefully of strings) and returns an array of floats
static func array_to_float_array(array: Array) -> Array[float]:
	var output: Array[float]
	output.resize(array.size())
	for i in range(array.size()):
		output[i] = float(array[i])
	
	return output

# takes an array of anything and an array of float weights
# returns a random element from the first array based on the weights
# in the second
static func pick_random_weighted(items: Array, weights: Array[float]):
	if items.size() != weights.size():
		assert(false, "item and weights array differ in size")
		return items.pick_random()
		
	var weight_sum = weights.reduce(func(accum, number): return accum + number, 0)
	var rand = randf_range(0, weight_sum)
	
	for i in range(items.size()):
		rand -= weights[i]
		if rand <= 0:
			return items[i]
	
	assert(false, "something is wrong with this function")
	return items.pick_random()

##takes one of the row or column names found in the json files such as 
##NEED_DARKNESS or NPC_STUDENT to Darkness and Student respectively.
###then returns the string whether it changed or not.
##Not great, I know.
static func canonise_string(input: String) -> String:
	if input.begins_with("NEED_"):
		#removes this prefix
		input = input.substr(5)
	elif input.begins_with("NPC_"):
		input = input.substr(4)
	input = input.capitalize()
	return input

##takes a need like NEED_DARKNESS and outputs the potion name,
##like Potion of Darkness. This is probably implemented elsewhere
## in the alchemy system but they have reasons to be different
static func need_to_potion_name(input: String) -> String:
	input = canonise_string(input)
	return "Potion of %s" % input
