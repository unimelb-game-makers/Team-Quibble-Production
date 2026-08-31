extends Node

#parameters
var customers_per_day: int = 12
var day_start_hour: int = 6
var day_length: int = 12

#actual variables
var day_progress: float = 0
var days_passed: int = 0

signal day_complete
signal day_started

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		progress_day()
		print_debug(day_progress)
		print_debug(day_progress_to_time_string())

func day_progress_to_time_string() -> String:
	var hour: int = int(wrap(day_start_hour + day_progress * day_length, 1, 13))
	var minute: int = 0
	#divide by zero
	if day_progress == 0:
		minute = 0
	else:
		60 * fmod(day_progress, day_progress/day_length)
	return "%02d:%02d" % [hour, minute]

func get_day_progress_increment() -> float:
	return 1.0/customers_per_day
	
##progresses the day by either a custom amount or by an amout dependent on
##number of customers per day. returns true if this ended the day,
##false otherwise
func progress_day(is_custom: bool = false, increment: float = 0) -> bool:
	if not is_custom:
		increment = get_day_progress_increment()
	day_progress += increment
	
	if day_progress > 1:
		day_progress = 0
		end_day()
		return true
	
	return false

func start_day() -> void:
	day_started.emit()
	day_progress = 0

func end_day() -> void:
	day_complete.emit()
