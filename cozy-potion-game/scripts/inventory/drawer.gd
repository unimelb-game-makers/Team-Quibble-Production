extends Control


var cols : int
var rows : int
var max_slots : int

@onready var inv_grid: GridContainer = $Storage
@onready var hotbar_grid: HBoxContainer = $Hotbar
@onready var inv_component: InventoryComponent = $InvComponent

@onready var info_display: Sprite2D = $InfoDisplay/InfoDisplay
@onready var info_name: Label = $InfoDisplay/InfoName
@onready var info_description: Label = $InfoDisplay/InfoDescription

@onready var sort_button: MenuButton = $SortButton

var sort_keys : Array[Callable] = [
	func(a: ItemSlot, b: ItemSlot): 
		if a.stack.isEmpty:
			return false
		if b.stack.isEmpty:
			return true
		return a.stack.item_name.naturalnocasecmp_to(b.stack.item_name) < 0,
	func(a: ItemSlot, b: ItemSlot):
		return a.stack.quantity > b.stack.quantity,
	func(a: ItemSlot, b: ItemSlot):
		var ingre_list := Potion.potion_ingredient_index
		if a.stack.isEmpty:
			return false
		if b.stack.isEmpty:
			return true
		var a_ingre = ingre_list.get(a.stack.item_name)
		var b_ingre = ingre_list.get(b.stack.item_name)
		return a_ingre.healing < b_ingre.healing,
		]
var sort_index: int = 0

var drawer : Inventory
var hotbar : Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	sort_button.get_popup().add_item("Itemname", 0)
	sort_button.get_popup().add_item("Quantity", 1)
	sort_button.get_popup().add_item("Healing", 1)
	sort_button.get_popup().index_pressed.connect(set_sort_key)
	
	cols = 10
	rows = 5
	max_slots = cols * rows
	inv_grid.columns = cols
	
	gui_input.connect(inv_component.click_background)
	
	var filled_stacks := Inventory.create_empty_stacks(max_slots)
	var keys = Potion.potion_ingredient_index.keys()
	
	for i in range(keys.size()):
		filled_stacks[i].quantity = 40
		filled_stacks[i].item_name = keys[i]
	
	drawer = Inventory.new(inv_grid)
	drawer.spawn_slots(filled_stacks)
	drawer.sort_items(sort_keys[sort_index])
	inv_component.attach_inventory(drawer)
	
	
	hotbar = Inventory.new(hotbar_grid, 1)
	hotbar.spawn_slots(Inventory.create_empty_stacks(3))
	inv_component.attach_inventory(hotbar) 


func set_sort_key(index: int) -> void:
	sort_index = index
	sort_button.text = sort_button.get_popup().get_item_text(index)
	drawer.sort_items(sort_keys[sort_index])
