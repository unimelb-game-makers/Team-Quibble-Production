extends Minigame

const NOTEBOOK_ITEM_DISPLAY = preload("uid://tvqhfnp8lc0h")

@export var drawer_open_sfx: AudioStream
@export var drawer_close_sfx: AudioStream

@onready var storage: Drawer = $HBoxContainer/Storage
@onready var inventory_with_hover: HoverInventory = $HBoxContainer/Storage/InventoryWithHover
@onready var item_display: CenterContainer = $HBoxContainer/ItemDisplay

var output_stacks : Inventory
var notebook : NotebookItemDisplay = null

func _ready() -> void:
	storage.leave_drawer.connect(set_output)
	AudioManager.play_audio(drawer_close_sfx)
	inventory_with_hover.slot_is_hovered.connect(change_displayed)


func set_output(stacks: Inventory) -> void:
	output_stacks = stacks
	win_minigame()

func win_minigame() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	minigame_won.emit(output_stacks)

func close_minigame() -> void:
	AudioManager.play_audio(drawer_close_sfx)


func add_notebook() -> void:
	notebook = NOTEBOOK_ITEM_DISPLAY.instantiate()
	item_display.add_child(notebook)
	notebook.show_background()
	item_display.visible = false


func display_notebook() -> void:
	item_display.visible = true


func change_displayed(slot: ItemSlot) -> void:
	if notebook == null:
		add_notebook()
		display_notebook()
	
	notebook.set_potion_ingredient(slot.get_item_stack().item)
