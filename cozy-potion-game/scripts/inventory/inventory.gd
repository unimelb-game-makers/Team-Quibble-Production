class_name Inventory
extends Resource


var item_slots : Array[ItemSlot]
var storage: Container

var max_quantity: int

func _init(contianer:Container = null, max_stack_size:int = 999) -> void:
	storage = contianer
	max_quantity = max_stack_size

# Creates list of empty stacks
static func create_empty_stacks(inv_size : int) -> Array[Stack]:
	var items :Array[Stack] = []
	items.resize(inv_size)
	for i in range(inv_size):
		items[i] = Stack.new()
	return items


# Spawns ItemSlots with currently parsed stacks
func spawn_slots(item_list: Array[Stack]) -> void:
	item_slots = []
	item_slots.resize(item_list.size())
	for i in range(item_list.size()):
		var new_instance := ItemSlot.get_item_scene().instantiate()
		storage.add_child(new_instance)
		
		item_slots[i] = new_instance
		new_instance.stack = item_list[i]


func clear_item_slots() -> void:
	for slot in item_slots:
		storage.remove_child(slot)


func copy_inventory(original : Inventory) -> void:
	clear_item_slots()
	
	spawn_slots(original.export_stacks())



# Adds new stack to the inventory priotising adding to existing stacks 
func blind_add_stack(new_item: Stack) -> Stack:
	# Adds to existing stacks
	for i in range(item_slots.size()):
		if item_slots[i].stack.compare_items(new_item):
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
		slot.stack = Stack.new(0, new_item.item)
	elif not slot.stack.compare_items(new_item):
		return new_item
	
	var add_to_stack : int = \
		min(max_quantity - slot.stack.quantity, \
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


# Makes items in pantry be alphabetically ordered, expandable to different keys
func sort_items(sort_func: Callable) -> void:
	item_slots.sort_custom(sort_func)
	
	for node in item_slots:
		storage.remove_child(node)
	
	for node in item_slots:
		storage.add_child(node)


func export_stacks() -> Array[Stack]:
	var stacks : Array[Stack]
	for slot in item_slots:
		stacks.append(slot.stack)
	
	return stacks
