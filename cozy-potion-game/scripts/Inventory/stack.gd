class_name Stack
extends Node

var quantity : int:
	set(value):
		quantity = value
		if value == 0:
			type = ItemType.EMPTY
var type : ItemType
# Items can have more than max_quanity if on ground
var max_grid_quantity: int = 10 # may not be constant later

enum ItemType {EMPTY, STONE, WOOD}

func _init(start_quantity: int) -> void:
	quantity = start_quantity

func clone_type(item : Stack) -> Stack:
	type = item.type
	
	return self

func get_sprite() -> Texture2D:
	if type == ItemType.EMPTY:
		return null
	return load("uid://2vnd31yby45a")


func get_quantity_label() -> String:
	if quantity == 0:
		return ""
	return str(quantity)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
