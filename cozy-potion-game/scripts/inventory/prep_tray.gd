extends Control

var num_slots : int

@onready var inv_storage: HBoxContainer = $HBoxContainer
@onready var inv_component: InventoryComponent = $InvComponent


func _ready() -> void:
	num_slots = 5
	# Create connection to inventory
	gui_input.connect(inv_component.click_background)
	var start_stacks := inv_component.create_empty_stacks(num_slots)
	inv_component.spawn_slots(inv_storage, start_stacks)
	
	inv_component.blind_add_stack(Stack.new(1, "Apple"))
