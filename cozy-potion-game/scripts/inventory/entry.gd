class_name Entry
extends Node

# Currently a copy of ItemSlot, should be updated in future for UI

static var entry_slot_scene := preload("uid://78h1y85wird5")

var stack : Stack :
	set(value):
		if stack != value:
			if value != null:
				value.updated_values.connect(update_stack)
			if stack != null:
				stack.updated_values.disconnect(update_stack)
		stack = value
		update_stack()

@onready var item_sprite: Sprite2D = $ItemSprite
@onready var quantity_label: Label = $QuantityLabel

func _ready() -> void:
	stack = Stack.new(0)

# Updates stack visuals to current stack
func update_stack() -> void:
	item_sprite.texture = stack.get_sprite()
	quantity_label.text = stack.get_quantity_label()
