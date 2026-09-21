class_name HoverInventory
extends Control

@onready var grid: GridContainer = $GridContainer

@onready var info_sheet: TextureRect = $InfoSheet
@onready var info_name: Label = $InfoSheet/ItemName
@onready var info_attributes: Label = $InfoSheet/ItemAttributes

@export var columns: int
@export var rows: int

var max_slots: int

var inventory: Inventory

var info_on:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_slots = columns*rows
	grid.columns = columns
	inventory = Inventory.new(grid)
	inventory.spawn_slots(Inventory.create_empty_stacks(max_slots))
	inventory.item_slot_mouse_entered.connect(item_slot_entered)
	inventory.item_slot_mouse_exited.connect(item_slot_exited)
	
	info_sheet.visible = false


func _process(delta: float) -> void:
	if info_on:
		if Input.is_action_pressed("LMB"):
			info_sheet.visible = false
		else:
			info_sheet.visible = true
			info_sheet.global_position = get_global_mouse_position()+Vector2(100,100)


func item_slot_entered(slot: ItemSlot) -> void:
	if not slot.get_item_stack().isEmpty:
		info_sheet.visible = true
		info_on = true
		info_name.text = slot.get_item_stack().get_item_name()


func item_slot_exited(slot: ItemSlot) -> void:
	info_sheet.visible = false
	info_on = false
