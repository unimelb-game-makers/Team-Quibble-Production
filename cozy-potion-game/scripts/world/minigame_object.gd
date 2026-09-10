class_name MinigameObject extends Node3D

@export var minigame_scene: PackedScene
@export var interactable: Interactable
var popup_subwindow: PopupSubWindow

func _ready() -> void:
	interactable.interacted.connect(_on_interact)
	popup_subwindow = get_tree().get_first_node_in_group(Utils.Group.GROUP_POPUP_SUBWINDOW)

func _on_interact():
	popup_subwindow.start_display_popup(minigame_scene)
