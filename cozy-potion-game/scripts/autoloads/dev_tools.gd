extends Node

@export var debug_panel: Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_panel.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_console"):
		debug_panel.visible = !debug_panel.visible
