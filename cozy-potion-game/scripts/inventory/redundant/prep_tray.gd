extends Control

var num_slots : int

@onready var inv_storage: HBoxContainer = $HBoxContainer
@onready var inv_component: InventoryComponent = $InvComponent


func _ready() -> void:
	num_slots = 5
	# Create connection to inventory
	
	gui_input.connect(inv_component.click_background)
	var inv := Inventory.new(inv_storage)
	inv.spawn_slots(Inventory.create_empty_stacks(num_slots))
	inv_component.attach_inventory(inv)
