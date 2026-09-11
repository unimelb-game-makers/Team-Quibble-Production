class_name Hotbar extends Container

#a resource that allows for inventory actions
var inventory: Inventory

#this is used when we need to populate the hotbar with empty items
@export var hotbar_item_slot_scene: PackedScene
@export var acceptor: DraggableAcceptorComponent

func _ready() -> void:
	inventory = Inventory.new(self)
	inventory.assign_slots(Inventory.create_empty_stacks(3), get_item_slot_children())
	acceptor.accepted_draggable.connect(_on_accept)

func _on_accept(control: Control):
	pass

func repopulate() -> void:
	var new = hotbar_item_slot_scene.instantiate()
	inventory.item_slots.append(new)
	add_child(new)

func get_item_slot_children() -> Array[ItemSlot]:
	var res: Array[ItemSlot]
	for child in get_children():
		if child is ItemSlot:
			res.append(child)
	
	return res
