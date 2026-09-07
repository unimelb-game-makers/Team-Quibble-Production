extends Node

var current_news_event: NewsEvent

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
	return current_news_event.headline

func get_news_description() -> String:
	return current_news_event.description

##internal use, use set_new_news_event
##creates a news event dictionary and makes some random modifications to it
func generate_news_event() -> NewsEvent:
	var news_json: JSON = Utils.get_json(NEWS_JSON_PATH)
	var events: Array = news_json.data
	
	var event_dict: Dictionary = events.pick_random()
	var event: NewsEvent = NewsEvent.new()
	event.initialise(event_dict)
	
	
	return event

func test_news() -> void:
	var news: NewsEvent = generate_news_event()
	assert(news.headline != "")
