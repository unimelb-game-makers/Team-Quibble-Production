extends Minigame

@export var drawer_open_sfx: AudioStream
@export var drawer_close_sfx: AudioStream

var output_stacks : Inventory
@onready var storage: Drawer = $Storage

func _ready() -> void:
	storage.leave_drawer.connect(set_output)
	Utils.audio_manager.play_audio(drawer_close_sfx)
	Utils.audio_manager.play_ambience(load("res://audio/sfx/portal/enter_portal2.wav"))



func set_output(stacks: Inventory) -> void:
	output_stacks = stacks
	win_minigame()

func win_minigame() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	minigame_won.emit(output_stacks)

func close_minigame() -> void:
	Utils.audio_manager.play_audio(drawer_close_sfx)
