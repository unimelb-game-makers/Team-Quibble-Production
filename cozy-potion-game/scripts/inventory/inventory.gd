class_name Inventory
extends Resource

signal hovering_slot
signal mouse_exit_slot

var item_slots : Array[ItemSlot]
var storage: Container
var max_quantity: int


# Creates list of empty stacks
static func create_empty_stacks(inv_size : int) -> Array[Stack]:
	var items: Array[Stack] = []
	items.resize(inv_size)
	for i in range(inv_size):
		items[i] = Stack.new()
	return items


# Parsed container is where all slots will be added
func _init(container: Container = null, max_stack_size:int = 999) -> void:
	storage = container
	max_quantity = max_stack_size


# Creates new slot from a stack, places it in a holder if stack is not empty
func add_new_slot_from_stack(item: Stack, trash_collector: Control) -> void:
	var new_item_slot: ItemSlot = ItemSlot.get_scene().instantiate()
	storage.add_child(new_item_slot)
	item_slots.append(new_item_slot)
	
	new_item_slot.max_quantity = max_quantity
	new_item_slot.trash_collector = trash_collector
	
	# Connections made for hovering slots
	# idk if this good considering you can use inventory without them
	new_item_slot.hovering.connect(hovering_slot_emit.bind(new_item_slot))
	new_item_slot.mouse_exited.connect(mouse_exit_slot_emit)
	
	if not item.isEmpty:
		new_item_slot.set_stack(item)


# Chains hovering signal from slots
func hovering_slot_emit(slot: ItemSlot) -> void:
	hovering_slot.emit(slot)


# Chains mouse_exited signal from slots
func mouse_exit_slot_emit() -> void:
	mouse_exit_slot.emit()


# Replaces itemslots with parsed stacks
func spawn_slots(item_list: Array[Stack], trash_collector: Control) -> void:
	# Removes previous slots
	for slot in item_slots:
		storage.remove_child(slot)
	
	item_slots = []
	for new_item in item_list:
		add_new_slot_from_stack(new_item, trash_collector)


# Currently unused
# Similar to the above, but accepts a premade list of slots.
func assign_slots(item_list: Array[Stack], slot_list: Array[ItemSlot]) -> void:
	item_slots.assign(slot_list)
	for i in range(item_list.size()):
		var slot: ItemSlot = slot_list[i]
		
		slot.stack = item_list[i]


# Adds new stack to the inventory prioritising adding to existing stacks
# Returns leftovers of stack
func blind_add_stack(new_item: Stack) -> Stack:
	# Adds to existing stacks
	for i in range(item_slots.size()):
		if item_slots[i].get_item_stack().compare_stacks(new_item):
			new_item = item_slots[i].add_stack(new_item)
			
			# If stack is now empty end
			if new_item.isEmpty:
				return new_item
	
	# Add to empty slots
	for i in range(item_slots.size()):
		if item_slots[i].get_item_stack().isEmpty:
			new_item = item_slots[i].add_to_stack(new_item)
			
			# If stack is now empty end
			if new_item.isEmpty:
				return new_item
	
	return new_item


# Adds amount from 1 stack to a slot
# Checks if same stack type and that amount is not more than stack quantity
func add_some_to_slot(stack: Stack, slot: ItemSlot, amount: int) -> Stack:
	# makes sure slot stack same as adding stack
	if slot.get_stack() != null and \
		not slot.get_stack().compare_stacks(stack):
		return stack
	# Prevents trying to add more than avaliable
	if amount > stack.quantity:
		return stack
	
	var clone := Stack.new(amount).clone_type(stack)
	stack.quantity -= amount
	return slot.add_stack_to_slot(clone)


# Orders items in inventory according to parsed sort key
func sort_items(sort_func: Callable) -> void:
	item_slots.sort_custom(sort_func)
	
	for node in item_slots:
		storage.remove_child(node)
	
	for node in item_slots:
		storage.add_child(node)


# Returns array of stacks current stored in inventory
func export_stacks() -> Array[Stack]:
	var stacks : Array[Stack]
	for slot in item_slots:
		stacks.append(slot.get_stack())
	
	return stacks


# Returns array of items currently stored in inventory, removes empty
func export_items() -> Array:
	var inventory_items: Array
	
	for slot in item_slots:
		var stack = slot.get_item_stack()
		if not stack.isEmpty:
			inventory_items.append(stack.item)
	
	return inventory_items
