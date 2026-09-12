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
	var items: Array[Stack] = []
	items.resize(inv_size)
	for i in range(inv_size):
		items[i] = Stack.new()
	return items



#creates a new slot from a stack and adds it to inventory
func add_new_slot_from_stack(item: Stack) -> void:
	var new_instance: ItemSlot = ItemSlot.get_item_scene().instantiate()
	storage.add_child(new_instance)
		
	item_slots.append(new_instance)
	new_instance.stack = item

# Spawns ItemSlots with currently parsed stacks
func spawn_slots(item_list: Array[Stack]) -> void:
	item_slots = []
	item_slots.resize(item_list.size())
	for i in range(item_list.size()):
		var new_instance: ItemSlot = ItemSlot.get_item_scene().instantiate()
		storage.add_child(new_instance)
		
		item_slots[i] = new_instance
		new_instance.stack = item_list[i]

# Spawns ItemSlots with currently parsed stacks
func spawn_hotbar_slots(item_list: Array[Stack]) -> void:
	item_slots = []
	item_slots.resize(item_list.size())
	for i in range(item_list.size()):
		var new_instance: ItemSlot = ItemSlot.get_hotbar_item_slot_scene().instantiate()
		storage.add_child(new_instance)
		
		item_slots[i] = new_instance
		new_instance.stack = item_list[i]

# Similar to the above, but accepts a premade list of slots.
func assign_slots(item_list: Array[Stack], slot_list: Array[ItemSlot]) -> void:
	item_slots.assign(slot_list)
	for i in range(item_list.size()):
		var slot: ItemSlot = slot_list[i]
		
		slot.stack = item_list[i]

func copy_inventory(original : Inventory) -> void:
	for slot in item_slots:
		storage.remove_child(slot)
	
	spawn_slots(original.export_stacks())

func copy_inventory_to_hotbar(original : Inventory) -> void:
	for slot in item_slots:
		storage.remove_child(slot)
	
	spawn_hotbar_slots(original.export_stacks())

# Similar to the above, but just sets the stack values of pre-
# existing item slots. Only functions up to the number of slots the
# targget inventory, ie the one executing this function
# has. Other slots from the incoming inventory are
# ignored
func assign_new_inventory(new_inventory: Inventory) -> void:
	for i in range(item_slots.size()):
		item_slots[i].stack = new_inventory.item_slots[i].stack

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
