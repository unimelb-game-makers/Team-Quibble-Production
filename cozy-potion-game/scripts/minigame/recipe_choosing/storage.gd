extends ScrollContainer

const INGREDIENT_SCENE = preload("uid://bevv56yxkl1y7") # draggable ui
#const INGREDIENT_SCENE = preload("uid://bq8fh7bhdr3an")

# please be more descriptive with the names of things :)
@onready var vbox: VBoxContainer = $Vbox

var dragging: bool = false # True if ingredient being dragged
var ingredient_dragging: Ingredient = null # Ingredient being dragged

func _ready() -> void:
	for ingredient in Potion.potion_ingredient_index.values():
		var instance = INGREDIENT_SCENE.instantiate()
		assert(instance is DraggableUI, "Scene instantiated was not of type Ingredient")

		vbox.add_child(instance)
		instance.set_resource(ingredient)
		# instance.get_dragbox().input_event.connect(start_dragging.bind(instance))

# If dragging, places dragged ingredient under mouse 
func _process(_delta: float) -> void:
	if dragging:
		if Input.is_action_just_released("LMB"):
			dragging = false
			ingredient_dragging.top_level = false
			ingredient_dragging = null
			
			queue_sort()
		else:
			ingredient_dragging.global_position = get_global_mouse_position()

# Called to make sort_ingredients() be called with queue_sort()
func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		sort_ingredients()

# Makes ingredients in storage be alphabetically ordered
func sort_ingredients() -> void:
	var sorted_nodes := vbox.get_children()
	
	sorted_nodes.sort_custom(
		func(a: DraggableUI, b: DraggableUI): 
			return a.ingredient_name.naturalnocasecmp_to(b.ingredient_name) < 0 \
		)
	
	for node in sorted_nodes:
		vbox.remove_child(node)
	
	for node in sorted_nodes:
		vbox.add_child(node)

# Called by scene script to get current dragging ingredient
func get_dragging_ingredient() -> Ingredient:
	if dragging:
		return ingredient_dragging
	return null



# Called when Ingredients feel input, trys to start dragging given ingredient
func start_dragging(_viewport: Node, event: InputEvent, _shape_idx: int, node) \
		-> void:
	print(_viewport)
	if !dragging and event.is_action_pressed("LMB"):
		dragging = true
		ingredient_dragging = node
		node.top_level = true
		
		# If previously on step, places under storage again
		node.reparent(vbox)
