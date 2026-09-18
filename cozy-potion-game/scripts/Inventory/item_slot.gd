class_name ItemSlot
extends Panel

var stack : Stack :
	set(value):
		if stack != value:
			if value != null:
				value.updated_values.connect(update_stack)
			if stack != null:
				stack.updated_values.disconnect(update_stack)
		stack = value
		update_stack()

@export var item_sprite: TextureRect
@export var quantity_label: Label
@export var draggable_component: DraggableComponent

static func get_item_scene() -> PackedScene:
	return preload("uid://b04fxmn4gaapy")

static func get_hotbar_item_slot_scene() -> PackedScene:
	return preload("uid://bcqi5ykyush3i")

func _ready() -> void:
	stack = Stack.new(0)

# Updates stack visuals to current stack
func update_stack() -> void:
	if stack:
		item_sprite.texture = stack.get_sprite()
		quantity_label.text = stack.get_quantity_label()
