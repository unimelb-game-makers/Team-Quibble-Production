extends Node

#parameters
const DAYS = ["Monday",
"Tuesday",
"Wednesday",
"Thursday",
"Friday",
"Saturday",
"Sunday",
]
#the speed that the day progresses when it has a time to progress towards
const day_progress_rate_per_second: float = 0.06
var customers_per_day: int = 12
var day_start_hour: int = 12
var day_length: int = 10

#actual variables
var day_progress: float = 0
var days_passed: int = 0
var target_day_progress: float = 0

signal day_complete
signal day_progress_changed
signal day_started

func _ready() -> void:
	#wait for other autoloads to connect their signals 
	await get_tree().process_frame
	start_day()

#this block is responsible for actually progressing the day towards
#the target day progress and checking if the day is over
func _process(delta: float) -> void:
	var init = day_progress

	day_progress = move_toward(day_progress, target_day_progress, day_progress_rate_per_second * delta)
	if is_equal_approx(day_progress_rate_per_second, 0) or day_progress_rate_per_second < 0:
		day_progress = target_day_progress
	
	#could cause issues at insanely high framerates, but i dont want to redraw 
	#the clock ui every frame in other cases
	if not is_equal_approx(init, day_progress):
		day_progress_changed.emit()
		
	if day_progress >= 1:
		end_day()
		
func day_progress_to_time_string() -> String:
	var hour: int = int(wrap(day_start_hour + day_progress * day_length, 1, 13))
	var minute: int = 0
	#divide by zero
	if day_progress == 0:
		minute = 0
	else:
		minute = ceil(wrap(60 * day_progress * day_length, 0, 60))
	return "%02d:%02d" % [hour, minute]

func days_passed_to_day_string() -> String:
	return DAYS[wrapi(days_passed,0, 7)]

func get_day_progress_increment() -> float:
	return 1.0/customers_per_day
	
##progresses the day by either a custom amount or by an amout dependent on
##number of customers per day. returns true if this ended the day,
##false otherwise
func progress_day(increment: float = 0):
	if not increment:
		increment = get_day_progress_increment()
	target_day_progress += increment
	



func start_day() -> void:
	day_started.emit()
	day_progress = 0
	target_day_progress = 0
	days_passed += 1
	day_progress_changed.emit()

func end_day() -> void:
	day_complete.emit()
	#TODO tie this to some ui input after results screen
	start_day()
