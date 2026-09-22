extends Minigame
#controller for mortar and pestle scene

var output_stacks : Inventory
@onready var storage: Drawer = $Storage

func _ready() -> void:
	storage.leave_drawer.connect(set_output)

func set_hotbar(new_hotbar: Inventory, new_input_index: int) -> void:
	super(new_hotbar, new_input_index)
	storage.hotbar.copy_inventory_to_hotbar(new_hotbar)
	# poor design here, causes redudant connections
	storage.inv_component.attach_inventory(storage.hotbar)

func set_output(stacks: Inventory) -> void:
	output_stacks = stacks
	win_minigame()

func win_minigame() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	minigame_won.emit(output_stacks)
