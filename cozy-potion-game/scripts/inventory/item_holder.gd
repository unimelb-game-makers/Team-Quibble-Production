class_name ItemHolder
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

static func get_scene() -> PackedScene:
	return preload("uid://80sdcv4hsqa1")

func _ready() -> void:
	stack = Stack.new(0)
	mouse_entered.connect(show_hover_information)
	mouse_exited.connect(hide_hover_information)


# Updates stack visuals to current stack
func update_stack() -> void:
	if stack:
		item_sprite.texture = stack.get_sprite()
		quantity_label.text = stack.get_quantity_label()


func get_stack() -> Stack:
	return stack


func show_hover_information() -> void:
	## TODO Relies on stack being different
	pass


func hide_hover_information() -> void:
	## TODO relies on stack being different
	pass
