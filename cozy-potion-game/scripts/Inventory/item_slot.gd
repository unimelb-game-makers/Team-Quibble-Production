class_name ItemSlot
extends Node

@onready var item_sprite: Sprite2D = $ItemSprite
@onready var quantity_label: Label = $QuantityLabel

var stack: Stack = null
static var item_slot_scene := preload("uid://b04fxmn4gaapy")


func set_item(new_stack: Stack) -> void:
	stack = new_stack
	update_item()

func update_item() -> void:
	item_sprite.texture = stack.get_sprite()
	if stack.quantity > 0 :
		quantity_label.text = stack.get_quantity_label()
	else:
		quantity_label.text = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
