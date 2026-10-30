class_name Drawer
extends Control

signal leave_drawer

var cols : int
var rows : int
var max_slots : int

@onready var hover_inv: HoverInventory = $InventoryWithHover

@onready var sort_button: MenuButton = $SortButton


var sort_keys : Array[Callable] = [
	func(a: ItemSlot, b: ItemSlot): 
		if a.get_item_stack().isEmpty:
			return false
		if b.get_item_stack().isEmpty:
			return true
		return a.get_item_stack().get_item_name().naturalnocasecmp_to(b.get_item_stack().get_item_name()) < 0,
	func(a: ItemSlot, b: ItemSlot):
		return a.get_item_stack().quantity > b.get_item_stack().quantity,
		]

var sort_index: int = 0

var drawer : Inventory
var hotbar : Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sort_button.get_popup().add_item("Itemname", 0)
	sort_button.get_popup().add_item("Quantity", 1)
	sort_button.get_popup().index_pressed.connect(set_sort_key)
	
	var filled_stacks := Inventory.create_empty_stacks(hover_inv.max_slots)
	var ingredients = Alchemy.ingredient_list
	
	#fill_stacks_from_pantry()
	
	for i in range(ingredients.size()):
		filled_stacks[i].quantity = 40
		filled_stacks[i].item = ingredients[i]
	
	hover_inv.inventory.spawn_slots(filled_stacks)
	hover_inv.inventory.sort_items(sort_keys[sort_index])

func fill_stacks_from_pantry() -> void:
	var empty_stacks = hover_inv.inventory.create_empty_stacks(40)
	for item in PersistentInventory.pantry:
		## we need to make a copy because adding stacks operates on the 
		## argument
		var copy: Stack = Stack.new(item.quantity, item.item)
		hover_inv.inventory.blind_add_stack(copy)

func update_inventory_to_match_drawer() -> void:
	var new_pantry: Array[Stack] 
	new_pantry.assign(hover_inv.inventory.export_stacks())
	PersistentInventory.pantry.assign(new_pantry)

func set_sort_key(index: int) -> void:
	sort_index = index
	sort_button.text = sort_button.get_popup().get_item_text(index)
	hover_inv.inventory.sort_items(sort_keys[sort_index])


func _exit_tree() -> void:
	update_inventory_to_match_drawer()

func update_large_info() -> void:
	
	pass
