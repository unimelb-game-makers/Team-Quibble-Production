extends Node

var current_news_event: Dictionary

const NEWS_JSON_PATH: String = "res://scripts/autoloads/news_events.json"
func _ready() -> void:
	TimeCycle.day_started.connect(set_new_news_event)
	set_new_news_event()

func set_new_news_event() -> void:
	current_news_event = generate_news_event()

func generate_news_event() -> Dictionary:
	return {"placeholder":"placeholder"}
