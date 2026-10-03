extends Minigame

var output_stacks : Inventory
var notebook : Notebook = null

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

const NOTEBOOK = preload("uid://bgulnwmxdnlnl")

# Cheat to see it, also idk if it counts as a minigame
func display_notebook() -> void:
	var popup_subwindow = get_tree().get_first_node_in_group(Utils.Group.GROUP_POPUP_SUBWINDOW)
	notebook = popup_subwindow.start_return_display_popup(NOTEBOOK)


func change_displayed(slot: ItemSlot) -> void:
	if not Input.is_action_pressed("RMB"):
		return
	
	if notebook == null:
		display_notebook()
	
	notebook.set_display(slot.get_item_stack().item)
