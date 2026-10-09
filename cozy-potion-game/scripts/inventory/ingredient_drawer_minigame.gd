extends Minigame

@export var drawer_open_sfx: AudioStream
@export var drawer_close_sfx: AudioStream

var output_stacks : Inventory
@onready var storage: Drawer = $Storage
@onready var audio_player: AudioPlayer = $AudioStreamPlayer

func _ready() -> void:
	storage.leave_drawer.connect(set_output)
	audio_player.play_audio(drawer_open_sfx)

func set_output(stacks: Inventory) -> void:
	output_stacks = stacks
	win_minigame()

func win_minigame() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	minigame_won.emit(output_stacks)

func close_minigame() -> void:
	audio_player.play_audio(drawer_close_sfx)
