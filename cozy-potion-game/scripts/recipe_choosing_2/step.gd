extends Control


@onready var method_button: MenuButton = $MethodButton
# Area2D for dragging ingredients
@onready var placebox: PlaceBox = $PlaceBox
# Holds Stored Ingredient
@onready var ingredient_box: CenterContainer = $IngredientBox 

var choices: Array[String] # Methods in PopUpMenu
var stored_ingredient: Ingredient = null # Current ingredient in step
var method_id: int = -1 # Id of method recently chosen

func _ready() -> void:
	method_button.text = "Method?"
	
	method_button.get_popup().id_pressed.connect(method_choice)
	placebox.home =  ingredient_box
	placebox.draggable_placed.connect(ingredient_placed)
	
	pass


func get_placebox() -> PlaceBox:
	return placebox


func get_ingredientBox() -> CenterContainer:
	return ingredient_box

# Called when removing step, puts ingredients back in storage
func return_ingredient() -> void:
	if not ingredient_box.get_children().is_empty():
		ingredient_box.get_children()[0].return_to_box()

# Clears PopUpMenu, places new methods inside
func set_methods(new_methods:Array[String]) -> void:
	var popup = method_button.get_popup()
	popup.clear()
	
	choices = new_methods
	
	for i in range(0, new_methods.size()):
		popup.add_item(new_methods[i], i)
	pass


func get_methods() -> Array[String]:
	return choices

# Called when method chosen from PopUpMenu, parsing id of method chosen
func method_choice(num) -> void:
	method_id = num
	method_button.text = choices[num]

# Called when Final Button pressed, returning players selection
func get_info() -> Array[String]:
	# Makes sure non default values selected
	if stored_ingredient == null or method_id == -1:
		return []
	return [choices[method_id], stored_ingredient.get_info()]


func ingredient_placed(dragbox : DragBox) -> void:
	if stored_ingredient != null:
		stored_ingredient.reparent.call_deferred(stored_ingredient.get_dragbox().get_home())
	stored_ingredient = dragbox.parent
