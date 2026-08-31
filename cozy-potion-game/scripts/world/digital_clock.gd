class_name DigitalClockDisplay extends Control

@export var label: Label

func _ready() -> void:
	TimeCycle.day_progress_changed.connect(_on_day_progress_changed)
	_on_day_progress_changed()

func _on_day_progress_changed() -> void:
	label.text = TimeCycle.day_progress_to_time_string()
