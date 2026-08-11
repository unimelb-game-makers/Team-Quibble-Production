extends Node2D

# Holds all steps
@onready var step_holder: Node2D = $StepHolder
# Holds Ingredients
@onready var storage: ScrollContainer = $Storage
# Buttons moves to next Scene
@onready var final_button: Button = $FinalButton


func _ready() -> void:
	final_button.pressed.connect(end_scene)

# Called when placing ingredient, so new container can get dragged ingredient
func get_dragging() -> Ingredient:
	return storage.get_dragging_ingredient()

# Called when Final Button Pressed, gets selected choices, moves to next scene
func end_scene() -> void:
	print(step_holder.get_final_steps())
