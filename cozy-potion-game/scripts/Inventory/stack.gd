class_name Stack
extends Node


var item_name : String:
	set(value):
		item_name = value
		if value != "":
			isEmpty = false

var quantity : int:
	set(value):
		quantity = value
		if value == 0:
			isEmpty = true

# Items can have more than max_quanity if on ground
var max_grid_quantity: int = 10 # may not be constant later
var isEmpty = false


func _init(start_quantity: int) -> void:
	quantity = start_quantity


# clones type from parsed stack
func clone_type(stack : Stack) -> Stack:
	item_name = stack.item_name
	
	return self

# Returns sprite of current sprite
# Doesn't current do that thou
func get_sprite() -> Texture2D:
	if isEmpty:
		return null
	return Potion.potion_ingredient_index.get(item_name).sprite


# Returns quantity of stack and "" if stack is empty
func get_quantity_label() -> String:
	if isEmpty:
		return ""
	return str(quantity)
