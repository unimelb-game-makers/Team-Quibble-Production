extends Node
# This is a ductape solution. A better solution will probably need to be implemented in the future

# project group names
const Group = {
	GROUP_PLAYER = "player",
	GROUP_INTERACTABLE_OBJECTS = "interactable_objects",
	GROUP_POPUP_SUBWINDOW = "popup_subwindow"
}

static func get_json(path: String) -> JSON:
	var json_string: String = FileAccess.open(path, FileAccess.READ).get_as_text()
	var json_data: JSON = JSON.new()

	var parse_result = json_data.parse(json_string)
	if parse_result != OK:
		print_debug("Variable json_data was null. %s" % [json_data.get_error_message()])
		return null
	return json_data
