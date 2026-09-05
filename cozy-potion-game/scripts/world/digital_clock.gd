class_name DigitalClockDisplay extends Control

@export var time_label: Label
@export var day_label: Label
@export var advance_time_button: Button

func _ready() -> void:
	TimeCycle.day_progress_changed.connect(_on_day_progress_changed)
	_on_day_progress_changed()
	advance_time_button.pressed.connect(TimeCycle.progress_day)

func _on_day_progress_changed() -> void:
	time_label.text = TimeCycle.day_progress_to_time_string()
	day_label.text = TimeCycle.days_passed_to_day_string()
