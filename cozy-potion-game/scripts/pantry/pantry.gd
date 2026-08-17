class_name Pantry
extends Node

const SAVE_PATH = "user://pantry_save.json"

var items : Dictionary[String, Stack] = {}

@onready var storage: VBoxContainer = $Storage


func _ready() -> void:
	# Test code
	var s = Stack.new(1)
	s.item_name = "Wheat"
	add_stack(s)
	DiskSaver.save_stack_dict_to_disk(items, SAVE_PATH)
	
	items = {}
	
	var save_info = DiskSaver.load_stack_dict_from_disk(SAVE_PATH)
	if save_info != null:
		items = save_info
	
	respawn_all_entrys()
	
	var t = Stack.new(1)
	t.item_name = "Apple"
	add_stack(t)
	add_stack(t)


func spawn_entry(item_name: String) -> void:
	# Only displays slot of entry if some exist in storage
	if items[item_name].isEmpty:
		return
	
	# Spawns Entry (currently ItemSlots as unsure whats wanted)
	var new_instance := ItemSlot.item_slot_scene.instantiate()
	storage.add_child(new_instance)
	
	new_instance.gui_input.connect(entry_clicked.bind(new_instance))
	new_instance.stack = items[item_name]


# Spawns entrys with stacks stored, currently ItemSlots prob should be changed
func respawn_all_entrys() -> void:
	# Removes all current children
	for node in storage.get_children():
		node.queue_free()
	
	items.sort()
	for key in items.keys():
		# Spawns Entry (currently ItemSlots as unsure whats wanted)
		spawn_entry(key)


# Adds any missing entrys no currently spawned
func adds_entrys(item_name: String) -> void:
	var missing_keys = items.keys()
	
	for entry in storage.get_children():
		if entry.stack.item_name in missing_keys:
			missing_keys.erase(entry.stack.item_name)
	
	for key in missing_keys:
		spawn_entry(key)
	
	sort_pantry()

# Makes items in pantry be alphabetically ordered, expandable to different keys
func sort_pantry() -> void:
	var sorted_nodes := storage.get_children()
	
	sorted_nodes.sort_custom(
		func(a: ItemSlot, b: ItemSlot): 
			return a.stack.item_name.naturalnocasecmp_to(b.stack.item_name) < 0\
		)
	
	for node in sorted_nodes:
		storage.remove_child(node)
	
	for node in sorted_nodes:
		storage.add_child(node)


# Adds new stack to pre existing stack in pantry
func add_stack(new_stack : Stack) -> void:
	if not items.has(new_stack.item_name):
		items[new_stack.item_name] = Stack.new(0).clone_type(new_stack)
		items[new_stack.item_name].quantity += new_stack.quantity
		spawn_entry(new_stack.item_name)
		sort_pantry()
	else:
		items[new_stack.item_name].quantity += new_stack.quantity

# Takes amount away from stack in pantry, only works if amount atleast in pantry
func take_from_stack(item_name : String, amount: int) -> Stack:
	# Makes sure item avaliable to be taken at amount requested
	if not items.has(item_name) or items[item_name].quantity < amount:
		return Stack.new(0)
	
	items[item_name].quantity -= amount
	if items[item_name].quantity <= 0:
		respawn_all_entrys()
	
	return Stack.new(amount, item_name)


# Called when entry clicked on
func entry_clicked(event: InputEvent, entry: ItemSlot) -> void:
	if event.is_action_pressed("LMB"):
		print(entry.stack.item_name)
