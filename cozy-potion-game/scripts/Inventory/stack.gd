class_name Stack
extends Node

# My Idea for player hands is that the player stores a stack
# if empty they can pick up item, if full they swap or smthng
#

signal updated_values

var item : Resource:
	set(value):
		item = null
		if value != null:
			item = value.duplicate()
		update_stack()
		updated_values.emit()


var quantity : int:
	set(value):
		quantity = value
		if isEmpty != (value == 0):
			update_stack()
		updated_values.emit()

var isEmpty = false

var sprite: Texture


func _init(start_quantity: int = 0, new_item: Resource = null) -> void:
	quantity = start_quantity
	item = new_item


func update_stack() -> void:
	if item != null and quantity != 0:
		sprite = get_item_sprite()
		isEmpty = false
	else:
		sprite = null
		isEmpty = true


func get_item_name() -> String:
	if item is PotionIngredient:
		return item.ingredient_name
	elif item is Potion:
		return item.potion_name
	return ""


# Returns sprite of current item
func get_item_sprite() -> Texture2D:
	if item is PotionIngredient:
		return item.ingredient_sprite
	elif item is Potion:
		return null
	return null


# Returns sprite of currently held in stack
func get_sprite() -> Texture2D:
	return sprite


# clones type from parsed stack
func clone_type(stack : Stack) -> Stack:
	item = stack.item
	return self


func compare_items(comp_stack: Stack) -> bool:
	#Bad
	if comp_stack.item is PotionIngredient and item is PotionIngredient:
		comp_stack.item.process_applied.sort()
		item.process_applied.sort()
		if comp_stack.item.ingredient_id == item.ingredient_id \
			and comp_stack.item.process_applied == item.process_applied:
				return true
	
	elif comp_stack.item is Potion and item is Potion:
		if comp_stack.item.potion_id == item.potion_id:
				return true
	return false


# Returns quantity of stack and "" if stack is empty
func get_quantity_label() -> String:
	if isEmpty or quantity == 1:
		return ""
	return str(quantity)
