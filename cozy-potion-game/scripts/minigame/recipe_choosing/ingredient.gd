class_name Ingredient
extends Control

signal drag_me

@onready var drag_box: Area2D = $DragBox # Area2D for detecting mouse selection
@onready var label: Label = $Label # Text for ingredient

var mouse_inside: bool = false

# The orginal owner of ingredient, i.e. Storage/Vbox
var ingredient_box: VBoxContainer = null
# Poor used for sorting ingredients
var ingredient_name: String = ""

var ingredient_resource: PotionIngredient

func _ready() -> void:
	ingredient_box = get_parent()

	# this is a shit implementation but idc atm. If you are reworking this script, please make sure
	# to change it for a better one
	mouse_entered.connect(func(): mouse_inside = true)
	mouse_exited.connect(func(): mouse_inside = false)

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("LMB"):
		return

	if !mouse_inside:
		return

	drag_me.emit()	

func set_resource(_ingredient_resource: PotionIngredient) -> void:
	ingredient_resource = _ingredient_resource
	ingredient_name = ingredient_resource.name
	label.text = ingredient_name


func get_dragbox() -> Area2D:
	return drag_box


func get_info() -> String:
	return ingredient_name

# Called when dragged to ensure returns to orignal owner
func return_to_box() -> void:
	reparent(ingredient_box)
