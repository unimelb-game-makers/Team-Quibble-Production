class_name Ingredient
extends Control

@onready var dragbox: DragBox = $DragBox
@onready var label: Label = $Label # Text for ingredient

# The orginal owner of ingredient, i.e. Storage/Vbox
var ingredient_box: VBoxContainer = null
# Poor used for sorting ingredients
var ingredient_type: String = ""


func _ready() -> void:
	ingredient_box = get_parent()


func set_text(newtext: String) -> void:
	label.text = newtext
	ingredient_type = newtext


func get_info() -> String:
	return ingredient_type


func get_dragbox() -> DragBox: # IDK about this??
	return dragbox
