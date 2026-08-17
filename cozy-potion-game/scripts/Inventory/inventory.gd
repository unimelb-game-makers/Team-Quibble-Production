extends Control

var items : Array[Stack]
var item_slots: Array[ItemSlot]
var cols : int
var rows : int
var max_slots : int

var dragging := false
var stack_dragging : Stack = null

@onready var grid: GridContainer = $GridContainer
@onready var hand: Node2D = $Hand


func _ready() -> void:
	cols = 10
	rows = 5
	max_slots = cols * rows
	
	grid.columns = cols
	items = initate_items()
	spawn_slots()
	
	gui_input.connect(click_background)
	pass


# When Dragging puts hand onto mouse
func _process(_delta: float) -> void:
	if dragging:
		hand.global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("K"):
		blind_add_stack(Stack.new(9).clone_type(stack_dragging))


# Creates empty list of items in bag
func initate_items() -> Array[Stack]:
	var new_slots : Array[Stack]
	new_slots.resize(cols * rows)
	for x in range(cols):
		for y in range(rows):
			new_slots[x * rows + y] = Stack.new(0)
	
	#Temp Stuff to for testing
	new_slots[10].item_name = "Apple"
	#new_slots[20].item_name = "Apple"
	new_slots[10].quantity = 2
	#new_slots[20].quantity = 1
	return new_slots


# Spawns ItemSlots with stacks stored
func spawn_slots() -> void:
	item_slots.resize(cols * rows)
	for x in range(cols):
		for y in range(rows):
			var new_instance := ItemSlot.item_slot_scene.instantiate()
			grid.add_child(new_instance)
			
			new_instance.gui_input.connect(slot_clicked.bind(new_instance))
			item_slots[x * rows + y] = new_instance
			new_instance.stack = items[x * rows + y]


# Adds new stack to the inventory priotising adding to existing stacks 
func blind_add_stack(new_item: Stack) -> Stack:
	# Adds to existing stacks
	for i in range(item_slots.size()):
		if item_slots[i].stack.item_name == new_item.item_name:
			new_item = add_stack_to_slot(new_item, item_slots[i])
			
			# If stack is now empty end
			if new_item.isEmpty:
				return new_item
	
	# Add to empty slots
	for i in range(item_slots.size()):
		if item_slots[i].stack.isEmpty:
			new_item = add_stack_to_slot(new_item, item_slots[i])
			
			# If stack is now empty end
			if new_item.isEmpty:
				return new_item
	
	return new_item


# Adds stack to another stack in a slot up to a limit
func add_stack_to_slot(new_item: Stack, slot: ItemSlot) -> Stack:
	# Make sure valid to add item to slot 
	# (this creates weird redundancy thats semi nesscary, 
	# but like want to prevent misuse as well) 
	if slot.stack.isEmpty:
		slot.stack = Stack.new(0).clone_type(new_item)
	elif slot.stack.item_name != new_item.item_name:
		return new_item
	
	var add_to_stack : int = \
		min(slot.stack.max_grid_quantity - slot.stack.quantity, \
		new_item.quantity)
	
	slot.stack.quantity += add_to_stack
	new_item.quantity -= add_to_stack
	
	return new_item


# Adds amount from 1 stack to a slot
func add_some_to_slot(stack: Stack, slot: ItemSlot, amount: int) -> Stack:
	if amount <= stack.quantity:
		var clone := Stack.new(amount).clone_type(stack)
		stack.quantity -= amount
		return add_stack_to_slot(clone, slot)
	return stack


# Updates the hand to represent current dragging stack
func update_hand() -> void:
	hand.get_node("HandSprite").texture = stack_dragging.get_sprite()
	hand.get_node("QuantityLabel").text = stack_dragging.get_quantity_label()
	
	if stack_dragging.isEmpty:
		dragging = false
		stack_dragging.queue_free()
		stack_dragging = null


# Called when player clicks on item slot
func slot_clicked(event: InputEvent, slot: ItemSlot) -> void:
	if event.is_action_pressed("LMB"):
		if !dragging:
			dragging = true
			stack_dragging = slot.stack
			slot.stack = Stack.new(0)
		elif slot.stack.item_name == stack_dragging.item_name:
			stack_dragging = add_stack_to_slot(stack_dragging, slot)
		else:
			var swap_temp := stack_dragging
			stack_dragging = slot.stack
			slot.stack = swap_temp
		
		update_hand()
	
	elif event.is_action_pressed("RMB"):
		if dragging:
			add_some_to_slot(stack_dragging, slot, 1)
			update_hand()


# Called when background is clicked
func click_background(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		if dragging:
			# Dropping stuff
			stack_dragging.quantity = 0
			update_hand()
