class_name WorldMerchant extends Node3D

@export var interactable: Interactable
@export var merchant_ui: MerchantUI

func _ready() -> void:
	interactable.interacted.connect(_on_interact)
	
func _on_interact() -> void:
	merchant_ui.show()
	get_tree().get_first_node_in_group(Utils.Group.GROUP_PLAYER).accepting_control = false
