class_name Pantry
extends Node

const SAVE_PATH = "user://pantry_save.json"

var items : Dictionary[String, Stack] = {}
var slots : Dictionary[String, Entry] = {}

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
	
	spawn_all_entrys()
	
	var t = Stack.new(1)
	t.item_name = "Apple"
	add_stack(t)
	add_stack(t)


func spawn_entry(item_name: String) -> void:
	# Only displays slot of entry if some exist in storage
	if items[item_name].isEmpty:
		return
	
	# Spawns Entry
	var new_instance := Entry.get_item_scene().instantiate()
	storage.add_child(new_instance)
	
	new_instance.gui_input.connect(entry_clicked.bind(new_instance))
	new_instance.stack = items[item_name]
	slots[item_name] = new_instance


# Spawns entrys with stacks stored
func spawn_all_entrys() -> void:
	# Removes all current children
	for node in storage.get_children():
		node.queue_free()
	
	items.sort()
	for key in items.keys():
		spawn_entry(key)

func update_entrys() -> void:
	var change := false
	for key in items.keys():
		if not slots.has(key) and items[key].quantity != 0:
			spawn_entry(key)
			change = true
		elif items[key].quantity == 0:
			slots[key].queue_free()
			change = true
	
	if change:
		sort_pantry()

# Makes items in pantry be alphabetically ordered, expandable to different keys
func sort_pantry() -> void:
	var sorted_nodes := slots.values()
	
	sorted_nodes.sort_custom(
		func(a: Entry, b: Entry): 
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
	update_entrys()

# Takes amount away from stack in pantry, only works if amount atleast in pantry
func take_from_stack(item_name : String, amount: int) -> Stack:
	# Makes sure item avaliable to be taken at amount requested
	if not items.has(item_name) or items[item_name].quantity < amount:
		return Stack.new(0)
	
	items[item_name].quantity -= amount
	if items[item_name].quantity <= 0:
		update_entrys()
	
	return Stack.new(amount, item_name)


# Called when entry clicked on
func entry_clicked(event: InputEvent, entry: Entry) -> void:
	if event.is_action_pressed("LMB"):
		print(entry.stack.item_name)
