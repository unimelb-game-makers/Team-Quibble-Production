class_name HoverInventory
extends Control

@export var columns: int
@export var rows: int

var max_slots: int
var inventory: Inventory

# Grid used for inventory
@onready var grid: GridContainer = $GridContainer
# Info Sheet
@onready var info_sheet: PanelContainer = $InfoSheet
@onready var info_name: Label = $InfoSheet/MarginContainer/VBoxContainer/ItemName
@onready var info_attributes: Label = $InfoSheet/MarginContainer/VBoxContainer/ItemAttributes
# Looked up how to do above idk if this is great

func _ready() -> void:
	max_slots = columns*rows
	grid.columns = columns
	inventory = Inventory.new(grid)
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
	if Input.is_action_pressed("LMB") or slot.get_stack().isEmpty:
		info_sheet.visible = false
		return
	
	info_sheet.visible = true
	update_info_sheet(slot.get_stack())
	
	info_sheet.global_position = get_global_mouse_position()+Vector2(10,10)


# Set Info sheet based on item
func update_info_sheet(stack: Stack):
	info_name.text = stack.get_item_name()
	info_attributes.text = ""
	
	if stack.item is PotionIngredient:
		var keys : Array[Alchemy.AttributeID]= stack.item.attributes.keys()
		keys.sort_custom(func(a:Alchemy.AttributeID, b:Alchemy.AttributeID):\
				return stack.item.attributes[a] > stack.item.attributes[b])
		
		for att in keys:
			if stack.item.attributes[att] != 0:
				if info_attributes.text != "":
					info_attributes.text += "\n"
				info_attributes.text += Alchemy.AttributeID.keys()[att].substr(5) +\
					 ": " + str(stack.item.attributes[att])
		info_sheet.reset_size()


# Turns off info_sheet if mouse moves off a slot
func slot_exited() -> void:
	info_sheet.visible = false
