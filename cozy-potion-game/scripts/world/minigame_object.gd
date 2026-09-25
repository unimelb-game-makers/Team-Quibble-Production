class_name MinigameObject extends Node3D

@export var minigame_scene: PackedScene
@export var interactable: Interactable
@export var indicator_pos: Node3D

var popup_subwindow: PopupSubWindow
var indicator: Indicator

func _ready() -> void:
	interactable.interacted.connect(_on_interact)
	popup_subwindow = get_tree().get_first_node_in_group(Utils.Group.GROUP_POPUP_SUBWINDOW)
	indicator = indicator_pos.get_child(0)
	if indicator: indicator.set_pivot(indicator_pos.global_position)

func _on_interact():
	if indicator:
		indicator.visible = false
		
	popup_subwindow.start_display_popup(minigame_scene)
