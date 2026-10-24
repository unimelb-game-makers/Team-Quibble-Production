class_name ControlsOptionMenu
extends MarginContainer

const KEYBIND_ENTRY = preload("uid://dtsoufmiy8x8d")

static var STARTING_KEYBINDS : Dictionary[StringName, String] = {
	"LMB" : "LMB",
	"RMB" : "RMB",
	"K" : "K",
	"move_up" : "Move Up",
	"move_left" : "Move Left",
	"move_down" : "Move Down",
	"move_right" : "Move Right",
	"interact" : "Interact",
	"close_minigame" : "Close Window",
	"open_notebook" : "Notebook",
}

var keybinds : Array[StringName]
var rebinding_key : bool = false
var entry_changing: KeybindEntry = null

@onready var option_container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer


func _ready() -> void:
	set_process_input(false)
	keybinds = get_custom_input_maps()
	for key in keybinds:
		create_keybind_entry(key)


func _input(event: InputEvent) -> void:
	if rebinding_key and \
		((entry_changing.mouse_bind and event is InputEventMouseButton) ||
		(not entry_changing.mouse_bind and event is not InputEventMouse)):
		remap_key(event)
		get_viewport().set_input_as_handled()
		


func get_custom_input_maps() -> Array[StringName]:
	var custom: Array[StringName]
	
	# Other method
	# return STARTING_KEYBINDS.keys()
	
	for action in InputMap.get_actions():
		if not action.begins_with("ui_") and not action.begins_with("hide_"):
			custom.append(action)
			
	return custom


func create_keybind_entry(key_name: String) -> KeybindEntry:
	var entry : KeybindEntry = KEYBIND_ENTRY.instantiate()
	option_container.add_child(entry)
	
	entry.set_key(key_name)
	entry.request_new_bind.connect(start_rebinding)
	return entry


func start_rebinding(entry: KeybindEntry) -> void:
	if rebinding_key:
		return
	
	entry_changing = entry
	set_process_input(true)
	rebinding_key = true


func remap_key(event: InputEvent) -> void:
	if InputMap.has_action(entry_changing.key):
		InputMap.action_erase_events(entry_changing.key)
	
	InputMap.action_add_event(entry_changing.key, event)
	
	entry_changing.update_text()
	entry_changing = null
	set_process_input(false)
	rebinding_key = false
