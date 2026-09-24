class_name ItemHolder
extends Panel

@export var item_sprite: TextureRect
@export var quantity_label: Label
@export var clickable_component: ClickableComponent

# If stack updated reconnects stack update signal to new stack
var stack : Stack :
	set(value):
		if stack != value:
			if value != null:
				value.updated_values.connect(update_stack)
			if stack != null:
				stack.updated_values.disconnect(update_stack)
		stack = value
		update_stack()


static func get_scene() -> PackedScene:
	return preload("uid://80sdcv4hsqa1")


func _ready() -> void:
	stack = Stack.new(0)


# Updates slot visuals based on changes in stack
func update_stack() -> void:
	if stack:
		item_sprite.texture = stack.get_sprite()
		quantity_label.text = stack.get_quantity_label()


func get_item_stack() -> Stack:
	return stack


func take_from_stack(amount: int) -> Stack:
	var new_item := Stack.new().clone_type(stack)
	var take_amount : int = min(stack.quantity, amount)
	stack.quantity -= take_amount
	new_item.quantity += take_amount
	
	return new_item
