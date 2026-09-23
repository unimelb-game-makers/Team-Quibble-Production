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
		if a.get_stack().isEmpty:
			return false
		if b.get_stack().isEmpty:
			return true
		return a.get_stack().get_item_name().naturalnocasecmp_to(b.get_stack().get_item_name()) < 0,
	func(a: ItemSlot, b: ItemSlot):
		return a.get_stack().quantity > b.get_stack().quantity,
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
	
	for i in range(ingredients.size()):
		filled_stacks[i].quantity = 40
		filled_stacks[i].item = ingredients[i]
	
	hover_inv.inventory.spawn_slots(filled_stacks)
	hover_inv.inventory.sort_items(sort_keys[sort_index])


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("close_minigame"):
		#leave_drawer.emit(hotbar)


func set_sort_key(index: int) -> void:
	sort_index = index
	sort_button.text = sort_button.get_popup().get_item_text(index)
	hover_inv.inventory.sort_items(sort_keys[sort_index])
