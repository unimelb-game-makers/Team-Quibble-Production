class_name ItemSlot
extends Node

static var item_slot_scene := preload("uid://b04fxmn4gaapy")

var stack: Stack = null

@onready var item_sprite: Sprite2D = $ItemSprite
@onready var quantity_label: Label = $QuantityLabel

# Set stack to new stack
func set_item(new_stack: Stack) -> void:
	stack = new_stack
	update_stack()


# Updates stack visuals to current stack
func update_stack() -> void:
	item_sprite.texture = stack.get_sprite()
	quantity_label.text = stack.get_quantity_label()
