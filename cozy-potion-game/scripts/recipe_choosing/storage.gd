extends ScrollContainer


@onready var vbox: VBoxContainer = $Vbox


var base_ingredients: Array[String] = ["Mushroom", "Star Dust", "Monkey Paw", \
		"Coffee", "Blood", "Walrus Hair"]

var dragging: bool = false # True if ingredient being dragged
var ingre_dragging: Ingredient = null # Ingredient being dragged


func _ready() -> void:
	var ingredientScene = load("res://scenes/ingredient.tscn")
	
	for ingredient in base_ingredients:
		var instance = ingredientScene.instantiate()
		vbox.add_child(instance)
		instance.get_dragbox().input_event.connect(start_dragging.bind(instance))
		instance.set_text(ingredient)

# Called to make sort_ingredients() be called with queue_sort()
func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		sort_ingredients()

# Makes ingredients in storage be alphabetically ordered
func sort_ingredients() -> void:
	var sorted_nodes := vbox.get_children()
	
	sorted_nodes.sort_custom(
		func(a: Ingredient, b: Ingredient): 
			return a.ingre_type.naturalnocasecmp_to(b.ingre_type) < 0 \
		)
	
	for node in sorted_nodes:
		vbox.remove_child(node)
	
	for node in sorted_nodes:
		vbox.add_child(node)

# Called by scene script to get current dragging ingredient
func get_dragging_ingredient() -> Ingredient:
	if dragging:
		return ingre_dragging
	return null

# Called when Ingredients feel input, trys to start dragging given ingredient
func start_dragging(_viewport: Node, event: InputEvent, _shape_idx: int, node) \
		-> void:
	if !dragging and event.is_action_pressed("LMB"):
		dragging = true
		ingre_dragging = node
		node.top_level = true
		
		# If previously on step, places under storage again
		node.reparent(vbox)

# If dragging, places dragged ingredient under mouse 
func _process(_delta: float) -> void:
	if dragging:
		if Input.is_action_just_released("LMB"):
			dragging = false
			ingre_dragging.top_level = false
			ingre_dragging = null
			
			queue_sort()
		else:
			ingre_dragging.global_position = get_global_mouse_position()
