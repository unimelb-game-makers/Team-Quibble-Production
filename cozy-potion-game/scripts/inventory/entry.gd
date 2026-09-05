class_name Entry
extends ItemSlot

@onready var item_name_label: Label = $ItemNameLabel

static func get_item_scene() -> PackedScene:
	return preload("uid://78h1y85wird5")

func update_stack() -> void:
	super()
	item_name_label.text = stack.item_name
