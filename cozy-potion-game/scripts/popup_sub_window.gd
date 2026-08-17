extends Node2D

@onready var transform_node: Node2D = $Transform
@onready var animation_player : AnimationPlayer = $AnimationPlayer

var popup: Node


func start_display_popup(_popup: Node) -> void:
	popup = _popup
	transform_node.add_child(_popup)
	animation_player.play(&"fade_in")

func end_display_popup() -> void:
	## TODO: call a function on the popup to stop receiving input
	animation_player.play(&"fade_out")
	await animation_player.animation_finished
	transform_node.remove_child(popup)
