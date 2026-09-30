extends Minigame

var output_stacks : Inventory
@onready var storage: Drawer = $Storage
@onready var audio: AudioPlayerUI = $AudioPlayerUI

func _ready() -> void:
	audio.play_file("drawer_open")
	storage.leave_drawer.connect(set_output)

func set_output(stacks: Inventory) -> void:
	output_stacks = stacks
	audio.play_file("drawer_close")
	win_minigame()

func win_minigame() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	minigame_won.emit(output_stacks)
