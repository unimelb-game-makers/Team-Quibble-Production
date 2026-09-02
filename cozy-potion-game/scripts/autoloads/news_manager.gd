extends Node

var current_news_event: Dictionary

const NEWS_JSON_PATH: String = "res://scripts/autoloads/news_events.json"

signal new_news_event

func _ready() -> void:
	test_news()
	
	TimeCycle.day_started.connect(set_new_news_event)
	set_new_news_event()

func set_new_news_event() -> void:
	current_news_event = generate_news_event()
	new_news_event.emit()

func get_news_headline() -> String:
	return current_news_event["HEADLINE"]

func get_news_description() -> String:
	return current_news_event["DESCRIPTION"]

##internal use, use set_new_news_event to do that
func generate_news_event() -> Dictionary:
	var news_json: JSON = Utils.get_json(NEWS_JSON_PATH)
	var events: Array = news_json.data
	
	return events.pick_random()

func test_news() -> void:
	var news: Dictionary = generate_news_event()
	
	assert(news["HEADLINE"] != "")
