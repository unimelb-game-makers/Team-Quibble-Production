extends Node

const EVENT_PATH = "event:/102BPMShopMusicAfternoon-Daniel-edit-20260909-final"

const AFTERNOON = "AFTERNOON"
const NIGHT = "NIGHT"
const CONTINUE = "CONTINUE"

const NIGHT_HOUR := 17

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

const A_NEXTLOOP = "A_NextLoop"
const N_NEXTLOOP = "N_NextLoop"

var music: FmodEvent
var time_of_day: String = ""


func _ready() -> void:
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
	# If it is in editor, pause.
	if not OS.has_feature("standalone"): pause()

func pause() -> void:
	music.paused = true

func unpause() -> void:
	music.paused = false

func _on_day_progress_changed() -> void:
	update_time_of_day(TimeCycle.get_current_hour())

func update_time_of_day(hour: int) -> void:
	# 5pm = night mix
	var new_time := AFTERNOON if hour < NIGHT_HOUR else NIGHT
	# dont keep setting the same parameter every time the clock updates
	if new_time == time_of_day:
		return
	time_of_day = new_time
	
	# clear any queued loops from the previous mix
	for loop in [A_NEXTLOOP, N_NEXTLOOP]:
		music.set_parameter_by_name_with_label(loop, CONTINUE, true)
	
	music.set_parameter_by_name_with_label("TimeOfDay", time_of_day, true)
	print_debug("Mix changing to: ", time_of_day)

func _on_fmod_callback(data: Dictionary, type: int) -> void:
	# receive timeline marker notifications from the audio engine when specific events occur
	if type != FmodServer.FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_MARKER:
		return
	
	var loop_name: String = String(data.get("name", ""))
	# ignore markers that arent music loops
	if loop_name in (AFTERNOON_LOOPS + NIGHT_LOOPS):
		call_deferred("_on_loop_started", loop_name)

func _on_loop_started(loop_name: String) -> void:
	var parameter_name := A_NEXTLOOP if loop_name in AFTERNOON_LOOPS else N_NEXTLOOP
	
	# reset the jump so it doesnt repeat immediately
	music.set_parameter_by_name_with_label(parameter_name, CONTINUE, true)
	print("Current loop: ", loop_name)
	
	# if roll fails then follow next loop like normal
	var roll := randf() # number between 0.0 and 1.0
	if roll > RANDOM_LOOP_CHANCE:
		print_debug("No random jump - continuing normally")
		return
	
	randomise_next_loop(loop_name, parameter_name)

func randomise_next_loop(current_loop: String, parameter_name: String) -> void:
	# call list from correct mix
	var loops: Array[String] = AFTERNOON_LOOPS if parameter_name == A_NEXTLOOP else NIGHT_LOOPS
	
	var current_index: int = loops.find(current_loop)
	var choices: Array[String] = []
	
	# skip the immediate next loop because thats what continue already does
	# then grab the 3 loops after that as possible jumps
	for offset: int in range(2, 5):
		var next_index: int = (current_index + offset) % loops.size()
		choices.append(loops[next_index])
	
	var next_loop: String = choices.pick_random()
	
	# fmod will jump when the current loop reaches its boundary
	music.set_parameter_by_name_with_label(parameter_name, next_loop, true)
	print_debug("Random jump selected: ", current_loop, " -> ", next_loop)
