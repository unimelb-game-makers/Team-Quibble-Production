extends CanvasLayer


# Base methods used for prototype
const BASE_METHODS: Array[String] = ["Mortar", "Heat", "..."]

const STEP_SCENE = preload("uid://qmk6ifrtikov")

const MAX_STEPS = 3

# container for all steps
@onready var container: VBoxContainer = $StepContainer
@onready var add_step_button: Button = $AddStepButton
@onready var remove_step_button: Button = $RemoveStepButton

# Steps currently on screen
var num_steps: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_new_step()
	add_step_button.pressed.connect(create_new_step)
	
	remove_step_button.pressed.connect(remove_step)
	remove_step_button.disabled = true
	remove_step_button.visible = false

# Creates and appends new step
func create_new_step() -> void:
	if num_steps < MAX_STEPS:
		# Makes remove button appear
		remove_step_button.disabled = false
		remove_step_button.visible = true
		
		# Creates new Step
		var instance = STEP_SCENE.instantiate()
		container.add_child(instance)
		instance.get_placebox().input_event.connect(drop_ingredient.bind(instance))
		
		# Sets PopUpMenu methods
		instance.set_methods(BASE_METHODS)
		
		num_steps += 1
		
		# Updates position of Add and Remove buttons
		var new_y = instance.custom_minimum_size.y * (num_steps - 1)
		add_step_button.global_position.y = new_y
		remove_step_button.global_position.y = new_y + add_step_button.size.y
		
		# If max steps reached, prevent add button from appearing
		if num_steps >= MAX_STEPS:
			add_step_button.disabled = true
			add_step_button.visible = false

func remove_step() -> void:
	if num_steps > 1:
		# Makes add button useable
		add_step_button.disabled = false
		add_step_button.visible = true
		
		# Gets step to remove
		var remove_instance := container.get_children()[-1]
		num_steps -= 1
		
		# Updates position of Add and Remove button
		var new_y = remove_instance.custom_minimum_size.y * (num_steps - 1)
		add_step_button.global_position.y = new_y
		remove_step_button.global_position.y = new_y + add_step_button.size.y

		# Removes lastest step
		remove_instance.return_ingredient()
		remove_instance.queue_free()
		
		# Hides Remove button if only 1 step left
		if num_steps <= 1:
			remove_step_button.disabled = true
			remove_step_button.visible = false

# If ingredient dropped over step PlaceBox, places ingredient in step
func drop_ingredient(_viewport: Node, _event: InputEvent, _shape_idx: int, node) -> void:
	if Input.is_action_just_released("LMB"):
		# Semi Hardcoded idk what to do here
		var ingredient = get_tree().current_scene.get_dragging() 
		if ingredient == null:
			return
		
		# Returns previous ingredient to storage
		if node.stored_ingredient != null:
			node.stored_ingredient.return_to_box()
		
		# Stores and replaces new ingredient on selected step
		node.stored_ingredient = ingredient
		ingredient.reparent(node.get_ingredientBox())
		ingredient.position = Vector2.ZERO

# Called when Final Button pressed, returns step information
# If no info exists returns empty array
func get_final_steps() -> Array[PotionIngredient]:
	var steps = container.get_children()
	var result: Array[PotionIngredient]
	
	for step in steps:
		result.append(step.get_ingredient_box().get_child(0).ingredient_resource)
	
	print(result)

	return result
