extends Control

@onready var sub_viewport: SubViewport = $SubViewport
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var player: WorldPlayer = $"../Node3D/Player"

var popup: Node

func start_display_popup(_popup: Node) -> void:
	player.accepting_control = false
	
	popup = _popup
	sub_viewport.add_child(_popup)
	animation_player.play(&"fade_in")

func end_display_popup() -> void:
	animation_player.play(&"fade_out")
	await animation_player.animation_finished
	sub_viewport.remove_child(popup)
	
	player.accepting_control = true

## this was connected in-editor.
## TODO: set mechanically for all interactables in scene. this could be done by giving the interactable a group
func _on_interactable_object_interacted(_scene_to_load: PackedScene) -> void:
	start_display_popup(_scene_to_load.instantiate())
