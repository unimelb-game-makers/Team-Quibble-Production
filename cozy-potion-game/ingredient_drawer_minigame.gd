extends Minigame

var output_stacks : Inventory
@onready var storage: Drawer = $Storage

func _ready() -> void:
	storage.leave_drawer.connect(set_output)

func set_output(stacks: Inventory) -> void:
	output_stacks = stacks
	win_minigame()

func win_minigame() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	minigame_won.emit(output_stacks)
