## An area that exists to be a child of objects like forage items or
## work stations, etc. if the player pressed the interact button with
## this area overlapping their interact area, this area's 
## interact signal will be emitted.
class_name InteractableArea extends Area3D

@export var scene_to_load: PackedScene

signal interacted(_scene_to_load: PackedScene)

func on_interact() -> void:
	interacted.emit(scene_to_load)
