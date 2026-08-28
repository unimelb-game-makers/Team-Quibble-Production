class_name ItemSlot
extends Node

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

static func get_item_scene() -> PackedScene:
	return preload("uid://b04fxmn4gaapy")

func _ready() -> void:
	stack = Stack.new(0)

# Updates stack visuals to current stack
func update_stack() -> void:
	item_sprite.texture = stack.get_sprite()
	quantity_label.text = stack.get_quantity_label()
