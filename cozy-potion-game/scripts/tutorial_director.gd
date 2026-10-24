class_name TutorialDirector
extends Node

static var tutorial_day: bool = true

@export var custom_customer: Array[Customer]
@export var customer_manager: CustomerManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# customer_manager.generate_customer_queue([custom_customer[0]])
	tutorial_day = true
