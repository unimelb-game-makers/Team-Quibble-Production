class_name InteractableArea 
extends Area3D
# An area that exists to be a child of objects like forage items or
# work stations, etc. if the player pressed the interact button with
# this area overlapping their interact area, this area's 
# interact signal will be emitted.

@export var scene_to_load: PackedScene

signal interacted(_scene_to_load: PackedScene)

# this is called before _ready
func _init() -> void:
	add_to_group(Utils.Group.GROUP_INTERACTABLE_OBJECTS) # may seem overkill but trust

func _ready() -> void:
	assert(interacted.get_connections().size() > 0, 
			"Nothing is connected to this node's signal. Interaction Manager Missing")

func on_interact() -> void:
	interacted.emit(scene_to_load)
