class_name KeybindEntry
extends HBoxContainer

signal request_new_bind(entry: KeybindEntry)

var key : String = ""
var mouse_bind: bool = false

@onready var label: Label = $KeyName
@onready var button: Button = $Button


func _ready() -> void:
	button.pressed.connect(emit_bind_request)


func set_key(key_name: String) -> void:
	key = key_name
	# Other option
	#label.text = ControlsOptionMenu.STARTING_KEYBINDS[key_name]
	label.text = key_name
	var inputs = InputMap.action_get_events(key_name)
	if inputs.size() >= 1:
		button.text = get_key_text(inputs[0])
		
		if inputs[0] is InputEventMouse:
			mouse_bind = true


func update_text() -> void:
	# Other option
	# label.text = ControlsOptionMenu.STARTING_KEYBINDS[key_name]
	label.text = key
	button.text = InputMap.action_get_events(key)[0].as_text()


func get_key_text(event: InputEvent) -> String:
	if event is InputEventKey:
		if event.physical_keycode != KEY_NONE:
			return OS.get_keycode_string(event.physical_keycode)
		return OS.get_keycode_string(event.keycode)
	
	return event.as_text()


func emit_bind_request() -> void:
	button.release_focus()
	request_new_bind.emit(self)
