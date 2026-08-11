extends Node

const MAIN_MENU := preload("uid://bwmeocdqaeu4l")

@export var main_menu_button: Button

@onready var current_scene: Node = $UI/MainMenu

func _ready() -> void:
	main_menu_button.pressed.connect(main_menu)

func switch_scene(_old_scene: Node, _new_scene: Node) -> void:
	# might want _new_scene to be a PackedScene
	_old_scene.queue_free()
	current_scene = _new_scene
	$UI.add_child(_new_scene)

func main_menu() -> void:
	switch_scene(current_scene, MAIN_MENU.instantiate())
