class_name Pantry
extends Control

const SAVE_PATH = "user://pantry_save.json"

var items : Dictionary[String, Stack] = {}
var slots : Dictionary[String, Entry] = {}

@onready var storage: VBoxContainer = $Storage
@onready var hotbar: GridContainer = $Hotbar
@onready var inv_component: InventoryComponent = $InvComponent

@onready var info_display: Sprite2D = $InfoDisplay/InfoDisplay
@onready var info_name: Label = $InfoDisplay/InfoName
@onready var info_description: Label = $InfoDisplay/InfoDescription

var hotbar_cols : int = 3 # Unsure what wanted here

func _ready() -> void:
	
	hotbar.columns = hotbar_cols
	# Create connection to inventory
	var start_stacks := inv_component.create_empty_stacks(hotbar_cols)
	inv_component.spawn_slots(hotbar, start_stacks)
	
	info_display.texture = null
	
	spawn_all_entrys()
	
	for key in Potion.potion_ingredient_index.keys():
		var s = Stack.new(40, key)
		add_stack(s)
	"""
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
	"""

func _process(_delta: float) -> void:
	# Start dragging thing if cursor tried to drag off entry
	if Input.is_action_pressed("grab_inventory_item") and not still_on_panel \
		and clicked_panel:
		clicked_panel = false
		if inv_component.stack_dragging != null:
			add_stack(inv_component.stack_dragging)
			inv_component.stack_dragging = Stack.new(0)
		inv_component.pickup_stack(last_clicked_entry, 1)
		update_entrys()

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("grab_inventory_item"):
		var s := inv_component.drop_held()
		if s != null:
			add_stack(s)


func spawn_entry(item_name: String) -> void:
	# Only displays slot of entry if some exist in storage
	if items[item_name].isEmpty:
		return
	
	# Spawns Entry
	var new_instance := Entry.get_item_scene().instantiate()
	storage.add_child(new_instance)
	
	new_instance.gui_input.connect(entry_clicked.bind(new_instance))
	new_instance.mouse_exited.connect(mouse_left_panel.bind(new_instance))
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
			slots.erase(key)
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


func update_info_display(entry: Entry) -> void:
	var potion_entry : PotionIngredient =\
		Potion.potion_ingredient_index.get(entry.stack.item_name)
	info_display.texture = entry.stack.get_sprite()
	info_name.text = entry.stack.item_name
	info_description.text = ""
	info_description.text += "Healing: " + str(potion_entry.healing)
	info_description.text += "\nEnergy: " + str(potion_entry.energy)
	info_description.text += "\nCure: " + str(potion_entry.cure_disease)
	info_description.text += "\nPoison: " + str(potion_entry.poison)

var clicked_panel := false
var still_on_panel := false
var last_clicked_entry : Entry = null

func mouse_left_panel(entry: Entry) -> void:
	still_on_panel = false

# Called when entry clicked on
func entry_clicked(event: InputEvent, entry: Entry) -> void:
	if event.is_action_pressed("grab_inventory_item"):
		still_on_panel = true
		clicked_panel = true
		last_clicked_entry = entry
		
		update_info_display(entry)
