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

@onready var item_texture: TextureRect = $ItemTexture
@onready var quantity_label: Label = $QuantityLabel
@onready var background_texture: TextureRect = $Background

static func get_item_scene() -> PackedScene:
	return preload("uid://b04fxmn4gaapy")


func _ready() -> void:
	unhighlight() # set thing to black
	stack = Stack.new(0)


func unhighlight() -> void:
	background_texture.self_modulate = Color.BLACK


func highlight() -> void:
	background_texture.self_modulate = Color.GOLD


# Updates stack visuals to current stack
func update_stack() -> void:
	item_texture.texture = stack.get_sprite()
	quantity_label.text = stack.get_quantity_label()
