extends Minigame

var output_stacks : Inventory
var notebook : NotebookItemDisplay = null

@onready var storage: Drawer = $Storage
@onready var inventory_with_hover: HoverInventory = $Storage/InventoryWithHover


func _ready() -> void:
	storage.leave_drawer.connect(set_output)
	inventory_with_hover.slot_is_hovered.connect(change_displayed)

func set_output(stacks: Inventory) -> void:
	output_stacks = stacks
	win_minigame()

func win_minigame() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	minigame_won.emit(output_stacks)

const NOTEBOOK_PEDIA_VIEW = preload("uid://deay4dct1lmci")

# Cheat to see it, also idk if it counts as a minigame
func display_notebook() -> void:
	notebook = NOTEBOOK_PEDIA_VIEW.instantiate()
	add_child(notebook)
	notebook.set_item_grid_visbile(false)


func change_displayed(slot: ItemSlot) -> void:
	if notebook == null:
		display_notebook()
	
	notebook.set_potion_ingredient(slot.get_item_stack().item)
