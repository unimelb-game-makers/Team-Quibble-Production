class_name NewsPopup extends Control

@export var headline_label: Label
@export var description_label: Label
@export var accept_button: Button

func _ready() -> void:
	NewsManager.new_news_event.connect(_on_new_news_event)
	accept_button.pressed.connect(hide)
	hide()
	
func _on_new_news_event():
	show()
	headline_label.text = NewsManager.get_news_headline()
	description_label.text = NewsManager.get_news_description()
