class_name TutorialDirector
extends Node

static var tutorial_day: bool = true
static var portal_open: bool = false
static var portal_news_event_static: NewsEvent
static var customer_manager_queue: Array[Customer]

@export var custom_customer: Array[Customer]
@export var customer_manager: CustomerManager
@export var portal_news_event: NewsEvent


var day_one_resources: Array[Stack] = \
		[Stack.new(5, Alchemy.ingredient_list[Alchemy.IngredientID.INGR_APPLE]),
		 Stack.new(5, Alchemy.ingredient_list[Alchemy.IngredientID.INGR_SPARK_THISTLE])]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# customer_manager.generate_customer_queue([custom_customer[0]])	
	TimeCycle.tutorial_day_started.connect(_on_day_started)
	TimeCycle.day_started.connect(_on_other_day_started)
	portal_news_event_static = portal_news_event

func tutorial_day_one() -> void:
	TimeCycle.customers_per_day = 2
	customer_manager_queue = [custom_customer[0], custom_customer[1]]
	PersistentInventory.pantry.append(day_one_resources)

func tutorial_day_two() -> void:
	portal_open = true
	TimeCycle.customers_per_day = 3
	customer_manager_queue = [custom_customer[2], custom_customer[0], custom_customer[1]]

func _on_day_started() -> void:
	if TimeCycle.days_passed == 0:
		tutorial_day_one()

	elif TimeCycle.days_passed == 1:
		tutorial_day_two()

func _on_other_day_started() -> void:
	TimeCycle.day_started.disconnect(_on_other_day_started)
	tutorial_day = false
