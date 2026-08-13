extends ScrollContainer

# please be more descriptive with the names of things :)
@onready var vbox: VBoxContainer = $Vbox

# replace this with a method that retrieves ingredients from potion
var base_ingredients: Array[String] = ["Mushroom", "Star Dust", "Monkey Paw", \
		"Coffee", "Blood", "Walrus Hair"]

var dragging: bool = false # True if ingredient being dragged
var ingredient_dragging: Ingredient = null # Ingredient being dragged


func _ready() -> void:
	var ingredientScene = load("res://assets/prefabs/recipe_prototype_2/ingredient_2.tscn")
	
	for ingredient in base_ingredients:
		var instance = ingredientScene.instantiate()
		vbox.add_child(instance)
		
		instance.set_text(ingredient)
		instance.get_dragbox().home = vbox
		instance.get_dragbox().dropped.connect(sort_ingredients)

# Called to make sort_ingredients() be called with queue_sort()
func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		sort_ingredients()

# Makes ingredients in storage be alphabetically ordered
func sort_ingredients() -> void:
	var sorted_nodes := vbox.get_children()
	
	sorted_nodes.sort_custom(
		func(a: Ingredient, b: Ingredient): 
			return a.ingredient_type.naturalnocasecmp_to(b.ingredient_type) < 0 \
		)
	
	for node in sorted_nodes:
		vbox.remove_child(node)
	
	for node in sorted_nodes:
		vbox.add_child(node)
