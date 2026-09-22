class_name HoverInventory
extends Control

@export var columns: int
@export var rows: int

var max_slots: int
var inventory: Inventory

# Grid used for inventory
@onready var grid: GridContainer = $GridContainer
# Info Sheet
@onready var info_sheet: TextureRect = $InfoSheet
@onready var info_name: Label = $InfoSheet/ItemName
@onready var info_attributes: Label = $InfoSheet/ItemAttributes


func _ready() -> void:
	max_slots = columns*rows
	grid.columns = columns
	inventory = Inventory.new(grid)
	inventory.spawn_slots(Inventory.create_empty_stacks(max_slots))
	
	# Connections needed for hovering
	inventory.hovering_slot.connect(slot_hovered)
	inventory.mouse_exit_slot.connect(slot_exited)
	info_sheet.visible = false


# Turns info_sheet on if mouse is hovering over slot with stack inside
func slot_hovered(slot: ItemSlot) -> void:
	if Input.is_action_pressed("LMB") or slot.get_stack().isEmpty:
		info_sheet.visible = false
		return
	
	info_sheet.visible = true
	info_name.text = slot.get_stack().get_item_name()
	
	info_sheet.global_position = get_global_mouse_position()+Vector2(10,10)


# Turns off info_sheet if mouse moves off a slot
func slot_exited() -> void:
	info_sheet.visible = false
