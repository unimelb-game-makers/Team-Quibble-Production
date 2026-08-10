class_name Ingredient
extends Control

@onready var drag_box: Area2D = $DragBox # Area2D for detecting mouse selection
@onready var label: Label = $Label # Text for ingredient

# The orginal owner of ingredient, i.e. Storage/Vbox
var ingredient_box: VBoxContainer = null
# Poor used for sorting ingredients
var ingre_type: String = ""


func _ready() -> void:
	ingredient_box = get_parent()


func set_text(newtext: String) -> void:
	label.text = newtext
	ingre_type = newtext


func get_dragbox() -> Area2D:
	return drag_box


func get_info() -> String:
	return ingre_type

# Called when dragged to ensure returns to orignal owner
func return_to_box() -> void:
	reparent(ingredient_box)
