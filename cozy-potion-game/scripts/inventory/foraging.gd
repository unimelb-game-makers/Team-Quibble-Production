extends Control


var cols : int
var rows : int
var max_slots : int

@onready var inv_grid: GridContainer = $GridContainer
@onready var inv_component: InventoryComponent = $InvComponent


func _ready() -> void:
	cols = 10
	rows = 5
	max_slots = cols * rows
	inv_grid.columns = cols
	
	# Create connection to inventory
	gui_input.connect(inv_component.click_background)
	var inv := Inventory.new(inv_grid)
	inv.spawn_slots(Inventory.create_empty_stacks(max_slots))
	inv_component.attach_inventory(inv)
	
	inv.blind_add_stack(Stack.new(2, Alchemy.ingredient_list[0]))
	inv.blind_add_stack(Stack.new(2, Alchemy.ingredient_list[1]))
