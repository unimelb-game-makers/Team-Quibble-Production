## exists to make the day start when the shop loads, not on scene ready
class_name DayStarter extends Node

static var fired: bool = false

func _ready() -> void:
	await get_tree().process_frame

	if SaveManager.restoring_session:
		fired = true
		return

	if not fired:
		fired = true
		TimeCycle.start_day()
