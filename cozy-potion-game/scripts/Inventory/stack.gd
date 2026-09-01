class_name Stack
extends Node

# My Idea for player hands is that the player stores a stack
# if empty they can pick up item, if full they swap or smthng
#

signal updated_values

var item_name : String:
	set(value):
		item_name = value
		update_stack()
		updated_values.emit()

var quantity : int:
	set(value):
		quantity = value
		if isEmpty != (value == 0):
			update_stack()
		updated_values.emit()

# Items can have more than max_quanity if on ground
const MAX_QUANTITY: int = 10
var isEmpty = false

var sprite: Texture

func _init(start_quantity: int = 0, start_name: String = "") -> void:
	quantity = start_quantity
	item_name = start_name


func update_stack() -> void:
	if item_name != "" and quantity != 0:
		sprite = Potion.potion_ingredient_index.get(item_name).sprite
		isEmpty = false
	else:
		sprite = null
		isEmpty = true


# clones type from parsed stack
func clone_type(stack : Stack) -> Stack:
	item_name = stack.item_name
	return self


# Returns sprite of current sprite
func get_sprite() -> Texture2D:
	return sprite

var color: Color
func get_color() -> Color:
	return color

# Returns quantity of stack and "" if stack is empty
func get_quantity_label() -> String:
	if isEmpty or quantity == 1:
		return ""
	return str(quantity)
