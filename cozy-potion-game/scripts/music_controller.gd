extends Node


const EVENT_PATH = "event:/102BPMShopMusicAfternoon-Daniel-edit-20260909-final"

const AFTERNOON = "AFTERNOON"
const NIGHT = "NIGHT"
const CONTINUE = "CONTINUE"

# chance for the music to skip ahead
const RANDOM_LOOP_CHANCE = 0.50


const AFTERNOON_LOOPS: Array[String] = [
	"LOOP1_AFTERNOON",
	"LOOP2_SYNTH",
	"LOOP3_GUITAR",
	"LOOP4_MARIMBA",
	"LOOP5_BIGSYNTH",
	"LOOP6_PIANO",
	"LOOP7_GRITTYSYNTH",
	"LOOP8_FLUTE",
	"LOOP9_OUTRO",
]


const NIGHT_LOOPS: Array[String] = [
	"N_LOOP1",
	"N_LOOP2_PIANOS",
	"N_LOOP3_SAX",
	"N_LOOP4_GUITAR",
	"N_LOOP5_MARIMBA",
	"N_LOOP6_BASS",
	"N_LOOP7_PIANOBASS",
	"N_LOOP8_EPIANOCHORD",
	"N_LOOP9_NOCHORDS",
]


var music: FmodEvent
var time_of_day: String = ""


func _ready() -> void:
	# wait for a frame for bank loader to initialise before getting fmod event
	await get_tree().process_frame

	music = FmodServer.create_event_instance(EVENT_PATH)

	# get timeline markers to report fmod loop
	music.set_callback(
		Callable(self, "_on_fmod_callback"),
		FmodServer.FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_MARKER
	)

	# update the music whenever the ingame clock moves
	TimeCycle.day_progress_changed.connect(_on_day_progress_changed)

	# make sure fmod starts with the correct time of day
	update_time_of_day(TimeCycle.get_current_hour())

	music.start()


func _on_day_progress_changed() -> void:
	update_time_of_day(TimeCycle.get_current_hour())


func update_time_of_day(hour: int) -> void:
	var new_time: String

	# 5pm = night mix
	if hour >= 17:
		new_time = NIGHT
	else:
		new_time = AFTERNOON

	# dont keep setting the same parameter every time the clock updates
	if new_time == time_of_day:
		return

	time_of_day = new_time

	# clear any queued loops from the previous mix
	music.set_parameter_by_name_with_label("A_NextLoop", CONTINUE, true)
	music.set_parameter_by_name_with_label("N_NextLoop", CONTINUE, true)

	music.set_parameter_by_name_with_label(
		"TimeOfDay",
		time_of_day,
		true
	)

	print("Mix changing to: ", time_of_day)

func _on_fmod_callback(data: Dictionary, type: int) -> void:
	# receive timeline marker notifications from the audio engine when specific events occur
	if type != FmodServer.FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_MARKER:
		return

	var loop_name: String = String(data.get("name", ""))

	# ignore markers that arent music loops
	if loop_name in AFTERNOON_LOOPS or loop_name in NIGHT_LOOPS:
		call_deferred("_on_loop_started", loop_name)


func _on_loop_started(loop_name: String) -> void:
	var parameter_name: String

	if loop_name in AFTERNOON_LOOPS:
		parameter_name = "A_NextLoop"
	else:
		parameter_name = "N_NextLoop"

	# reset the jump so it doesnt repeat immediately
	music.set_parameter_by_name_with_label(
		parameter_name,
		CONTINUE,
		true
	)

	print("Current loop: ", loop_name)

	# if roll fails then follow next loop like normal
	if randf() > RANDOM_LOOP_CHANCE:
		print("No random jump - continuing normally")
		return

	randomise_next_loop(loop_name, parameter_name)


func randomise_next_loop(current_loop: String, parameter_name: String) -> void:
	var loops: Array[String]

	# call list from correct mix
	if parameter_name == "A_NextLoop":
		loops = AFTERNOON_LOOPS
	else:
		loops = NIGHT_LOOPS

	var current_index: int = loops.find(current_loop)
	var choices: Array[String] = []

	# skip the immediate next loop because thats what continue already does
	# then grab the 3 loops after that as possible jumps
	for offset: int in range(2, 5):
		var next_index: int = (current_index + offset) % loops.size()
		choices.append(loops[next_index])

	var next_loop: String = choices.pick_random()

	# fmod will jump when the current loop reaches its boundary
	music.set_parameter_by_name_with_label(
		parameter_name,
		next_loop,
		true
	)

	print("Random jump selected: ", current_loop, " -> ", next_loop)
