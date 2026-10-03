class_name HoverInventory
extends Control

signal slot_is_hovered(slot: ItemSlot)

@export var columns: int
@export var rows: int
@export var max_quantity : int = 999

var max_slots: int
var inventory: Inventory

# Grid used for inventory
@onready var grid: GridContainer = $GridContainer
# Info Sheet
@onready var info_sheet: PanelContainer = $InfoSheet
@onready var info_name: Label = $InfoSheet/MarginContainer/VBoxContainer/ItemName


func _ready() -> void:
	max_slots = columns*rows
	grid.columns = columns
	inventory = Inventory.new(grid, max_quantity)
	inventory.spawn_slots(Inventory.create_empty_stacks(max_slots))
	
	# Connections needed for hovering
	inventory.hovering_slot.connect(slot_hovered)
	inventory.mouse_exit_slot.connect(slot_exited)
	info_sheet.visible = false


func get_inventory() -> Array[Resource]:
	var inventory_resources: Array[Resource]
	for item in inventory.item_slots:
		if item.item_holder != null:
			inventory_resources.append(item.item_holder.stack.item)
	return inventory_resources


# Turns info_sheet on if mouse is hovering over slot with stack inside
func slot_hovered(slot: ItemSlot) -> void:
	if Input.is_action_pressed("LMB") or slot.get_item_stack().isEmpty:
		info_sheet.visible = false
		return
	
	update_info_sheet(slot.get_item_stack())
	
	slot_is_hovered.emit(slot)

# Set Info sheet based on item
func update_info_sheet(stack: Stack):
	info_sheet.visible = true
	info_name.text = stack.get_item_name()
	
	info_sheet.global_position = get_global_mouse_position()+Vector2(10,10)
	# Used to have alot more


# Turns off info_sheet if mouse moves off a slot
func slot_exited() -> void:
	info_sheet.visible = false
