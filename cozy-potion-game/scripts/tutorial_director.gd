class_name TutorialDirector
extends Node

static var tutorial_day: bool = true
static var portal_open: bool = false
static var portal_news_event_static: NewsEvent

@export var custom_customer: Array[Customer]
@export var customer_manager: CustomerManager
@export var portal_news_event: NewsEvent

var customer_manager_queue: Array[Customer]
var day_one_resources: Array[Stack] = \
		[Stack.new(5, Alchemy.ingredient_list[Alchemy.IngredientID.INGR_APPLE]),
		 Stack.new(5, Alchemy.ingredient_list[Alchemy.IngredientID.INGR_SPARK_THISTLE])]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# customer_manager.generate_customer_queue([custom_customer[0]])
	tutorial_day = false
	return
	tutorial_day_one()
	TimeCycle.day_complete.connect(_on_day_finished)
	portal_news_event_static = portal_news_event

func tutorial_day_one() -> void:
	customer_manager_queue = [custom_customer[0], custom_customer[1]]
	PersistentInventory.pantry.append(day_one_resources)

func tutorial_day_two() -> void:
	portal_open = true

func _on_day_finished() -> void:
	if TimeCycle.days_passed == 1:
		tutorial_day_two()

	elif TimeCycle.days_passed > 1:
		tutorial_day = false