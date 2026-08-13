extends Node2D

# container for all steps
@onready var container: VBoxContainer = $StepContainer
@onready var add_step_button: Button = $AddStepButton
@onready var remove_step_button: Button = $RemoveStepButton

# Steps currently on screen
var num_steps: int = 0
const MAX_STEPS = 3

# Base methods used for prototype
const BASE_METHODS: Array[String] = ["Mortar", "Heat", "..."]

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
		var ingredientScene = load("res://assets/prefabs/recipe_prototype_2/step_2.tscn")
		var instance = ingredientScene.instantiate()
		container.add_child(instance)
		
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
