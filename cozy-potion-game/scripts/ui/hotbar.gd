class_name Hotbar extends Container

#a resource that allows for inventory actions
var inventory: Inventory

func _ready() -> void:
	inventory = Inventory.new(self)
	inventory.assign_slots(Inventory.create_empty_stacks(3), get_item_slot_children())

func get_item_slot_children() -> Array[ItemSlot]:
	var res: Array[ItemSlot]
	for child in get_children():
		if child is ItemSlot:
			res.append(child)
	
	return res
