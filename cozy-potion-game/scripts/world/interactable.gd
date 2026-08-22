##a class that does nothing but have an interacted signal that is emitted
## from it by the player and is listened to by certain objects which then 
## perform logic.
class_name Interactable extends Area3D

signal interacted

const INTERACTABLE_LAYER: int = 21

func _ready() -> void:
	set_collision_layer_value(INTERACTABLE_LAYER, true)
