extends Control

@export var options_button: Button
@export var continue_button: Button
@export var new_game_button: Button
@export var quit_button: Button

func _ready() -> void:
	continue_button.grab_focus()
