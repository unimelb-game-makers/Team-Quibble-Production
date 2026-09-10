class_name InventoryComponent
extends Node2D

@export var HandSprite : Sprite2D
@export var QuantityLabel : Label

var item_slots: Array[ItemSlot]
var max_slots : int

var dragging := false
var stack_dragging : Stack = null

# When Dragging puts hand onto mouse
func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position()
	
	# Test Code can be removed
	#if Input.is_action_just_pressed("K"):
		#blind_add_stack(Stack.new(9).clone_type(stack_dragging))


# Creates list of empty stacks
func create_empty_stacks(inv_size : int) -> Array[Stack]:
	var items :Array[Stack] = []
	items.resize(inv_size)
	for i in range(inv_size):
		items[i] = Stack.new(0)
	return items


# Spawns ItemSlots with currently parsed stacks
func spawn_slots(storage: Container, item_list: Array[Stack]) -> void:
	item_slots = []
	item_slots.resize(item_list.size())
	for i in range(item_list.size()):
		var new_instance := ItemSlot.get_item_scene().instantiate()
		storage.add_child(new_instance)
		
		new_instance.gui_input.connect(slot_clicked.bind(new_instance))
		item_slots[i] = new_instance
		new_instance.stack = item_list[i]


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
		min(slot.stack.MAX_QUANTITY - slot.stack.quantity, \
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
	HandSprite.texture = stack_dragging.get_sprite()
	QuantityLabel.text = stack_dragging.get_quantity_label()
	
	if stack_dragging.isEmpty:
		dragging = false
		stack_dragging.queue_free()
		stack_dragging = null


# Called when player clicks on item slot
func slot_clicked(event: InputEvent, slot: ItemSlot) -> void:
	if event.is_action_pressed("grab_inventory_item"):
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
	
	elif event.is_action_pressed("place_inventory_item"):
		if dragging:
			add_some_to_slot(stack_dragging, slot, 1)
			update_hand()


# Called when background is clicked
# Care as can active in gaps between slots
func click_background(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		if dragging:
			# Dropping stuff
			stack_dragging.quantity = 0
			update_hand()
