class_name Stack
extends Node

enum ItemType {EMPTY, STONE, WOOD}

var quantity : int:
	set(value):
		quantity = value
		if value == 0:
			type = ItemType.EMPTY
var type : ItemType
# Items can have more than max_quanity if on ground
var max_grid_quantity: int = 10 # may not be constant later


func _init(start_quantity: int) -> void:
	quantity = start_quantity


# clones type from parsed stack
func clone_type(item : Stack) -> Stack:
	type = item.type
	
	return self

# Returns sprite of current sprite
# Doesn't current do that thou
func get_sprite() -> Texture2D:
	if type == ItemType.EMPTY:
		return null
	return load("uid://dxjv147f0i0pi")


# Returns quantity of stack and "" if stack is empty
func get_quantity_label() -> String:
	if type == ItemType.EMPTY:
		return ""
	return str(quantity)
