extends Node2D

# container for all steps
@onready var container: VBoxContainer = $StepContainer
@onready var add_step_button: Button = $AddStepButton
@onready var remove_step_button: Button = $RemoveStepButton

# Steps currently on screen
var num_steps: int = 0
const MAX_STEPS = 3

# Base methods used for prototype
const base_methods: Array[String] = ["Mortar", "Heat", "..."]

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
		var ingredientScene = load("res://scenes/step.tscn")
		var instance = ingredientScene.instantiate()
		container.add_child(instance)
		instance.get_placebox().input_event.connect(drop_ingredient.bind(instance))
		
		# Sets PopUpMenu methods
		instance.set_methods(base_methods)
		
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
		var remove_inst := container.get_children()[-1]
		num_steps -= 1
		
		# Updates position of Add and Remove button
		var new_y = remove_inst.custom_minimum_size.y * (num_steps - 1)
		add_step_button.global_position.y = new_y
		remove_step_button.global_position.y = new_y + add_step_button.size.y

		# Removes lastest step
		remove_inst.return_ingredient()
		remove_inst.queue_free()
		
		# Hides Remove button if only 1 step left
		if num_steps <= 1:
			remove_step_button.disabled = true
			remove_step_button.visible = false

# If ingredient dropped over step PlaceBox, places ingredient in step
func drop_ingredient(viewport: Node, event: InputEvent, shape_idx: int, node) -> void:
	if Input.is_action_just_released("LMB"):
		# Semi Hardcoded idk what to do here
		var ingre = get_tree().current_scene.get_dragging() 
		if ingre == null:
			return
		
		# Returns previous ingredient to storage
		if node.stored_ingredient != null:
			node.stored_ingredient.return_to_box()
		
		# Stores and replaces new ingredient on selected step
		node.stored_ingredient = ingre
		ingre.reparent(node.get_ingredientBox())
		ingre.position = Vector2.ZERO

# Called when Final Button pressed, returns step information
# If no info exists returns empty array
func get_final_steps() -> Array[Array]:
	var steps = container.get_children()
	var result: Array[Array]
	
	for step in steps:
		var res = step.get_info()
		if res.is_empty():
			return []
		result.append(res)
		
	return result
