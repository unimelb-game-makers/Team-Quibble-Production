class_name Drawer
extends Control

signal leave_drawer

var cols : int
var rows : int
var max_slots : int

@onready var hover_inv: HoverInventory = $InventoryWithHover

@onready var sort_button: MenuButton = $SortButton
@onready var attribute_1: OptionButton = $AttributeFilters/Attribute1
@onready var attribute_2: OptionButton = $AttributeFilters/Attribute2
@onready var filter_mode_button: Button = $AttributeFilters/FilterModeButton

var filter_use_and: bool = false

var sort_keys : Array[Callable] = [
	func(a: ItemSlot, b: ItemSlot): 
		if a.get_item_stack().isEmpty:
			return false
		if b.get_item_stack().isEmpty:
			return true
		return a.get_item_stack().get_item_name().naturalnocasecmp_to(b.get_item_stack().get_item_name()) < 0,
	func(a: ItemSlot, b: ItemSlot):
		return a.get_item_stack().quantity > b.get_item_stack().quantity,
		]

var sort_index: int = 0

var drawer : Inventory
var hotbar : Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sort_button.get_popup().add_item("Itemname", 0)
	sort_button.get_popup().add_item("Quantity", 1)
	sort_button.get_popup().index_pressed.connect(set_sort_key)
	
	var filled_stacks := Inventory.create_empty_stacks(hover_inv.max_slots)
	var ingredients = Alchemy.ingredient_list
	
	fill_stacks_from_pantry()
	
	#for i in range(ingredients.size()):
		#filled_stacks[i].quantity = 40
		#filled_stacks[i].item = ingredients[i]
	#
	#hover_inv.inventory.spawn_slots(filled_stacks)
	#hover_inv.inventory.sort_items(sort_keys[sort_index])
	
	setup_attribute_filters()
	
	filter_mode_button.pressed.connect(toggle_filter_mode)
	filter_mode_button.text = "OR"

func fill_stacks_from_pantry() -> void:
	var empty_stacks = hover_inv.inventory.create_empty_stacks(40)
	for item in PersistentInventory.pantry:
		## we need to make a copy because adding stacks operates on the 
		## argument
		var copy: Stack = Stack.new(item.quantity, item.item)
		hover_inv.inventory.blind_add_stack(copy)

func update_inventory_to_match_drawer() -> void:
	var new_pantry: Array[Stack] 
	new_pantry.assign(hover_inv.inventory.export_stacks())
	PersistentInventory.pantry.assign(new_pantry)

func set_sort_key(index: int) -> void:
	sort_index = index
	sort_button.text = sort_button.get_popup().get_item_text(index)
	hover_inv.inventory.sort_items(sort_keys[sort_index])


func _exit_tree() -> void:
	update_inventory_to_match_drawer()

func update_large_info() -> void:
	
	pass

func setup_attribute_filters() -> void:
	for dropdown in [attribute_1, attribute_2]:
		dropdown.add_item("Any attribute", -1)

		for attribute_id in range(Alchemy.AttributeID.ATTR_NULL_ATTR):
			var attribute_name = Alchemy.AttributeID.keys()[attribute_id]
			attribute_name = attribute_name.trim_prefix("ATTR_").capitalize()

			dropdown.add_item(attribute_name, attribute_id)

		dropdown.item_selected.connect(update_attribute_filters)

	attribute_1.select(0)
	attribute_2.select(0)


func update_attribute_filters(_index: int = 0) -> void:
	var first = -1 if attribute_1.selected == 0 else attribute_1.get_selected_id()
	var second = -1 if attribute_2.selected == 0 else attribute_2.get_selected_id()

	for slot in hover_inv.inventory.item_slots:
		var stack = slot.get_item_stack()

		if first == -1 and second == -1:
			slot.show()
			continue

		if stack.isEmpty or not stack.item is PotionIngredient:
			slot.hide()
			continue

		var ingredient: PotionIngredient = stack.item

		var matches_first = (
			first == -1 or ingredient.attributes.get(first, 0) > 0
		)

		var matches_second = (
			second == -1 or ingredient.attributes.get(second, 0) > 0
		)

		if first == -1:
			slot.visible = matches_second
		elif second == -1:
			slot.visible = matches_first
		elif filter_use_and:
			slot.visible = matches_first and matches_second
		else:
			slot.visible = matches_first or matches_second

	if first == -1 and second == -1:
		hover_inv.inventory.sort_items(sort_keys[sort_index])
	else:
		hover_inv.inventory.sort_items(compare_attribute_strength)


func compare_attribute_strength(a: ItemSlot, b: ItemSlot) -> bool:
	var first = attribute_1.get_selected_id()
	var second = attribute_2.get_selected_id()

	var a_stack = a.get_item_stack()
	var b_stack = b.get_item_stack()

	if a_stack.isEmpty:
		return false
	if b_stack.isEmpty:
		return true

	var a_first = 0
	var b_first = 0
	var a_second = 0
	var b_second = 0

	if a_stack.item is PotionIngredient:
		if first >= 0:
			a_first = a_stack.item.attributes.get(first, 0)
		if second >= 0:
			a_second = a_stack.item.attributes.get(second, 0)

	if b_stack.item is PotionIngredient:
		if first >= 0:
			b_first = b_stack.item.attributes.get(first, 0)
		if second >= 0:
			b_second = b_stack.item.attributes.get(second, 0)

	if a_first != b_first:
		return a_first > b_first

	if a_second != b_second:
		return a_second > b_second

	return a_stack.get_item_name().naturalnocasecmp_to(
		b_stack.get_item_name()
	) < 0

func toggle_filter_mode() -> void:
	filter_use_and = not filter_use_and
	filter_mode_button.text = "AND" if filter_use_and else "OR"
	update_attribute_filters()
