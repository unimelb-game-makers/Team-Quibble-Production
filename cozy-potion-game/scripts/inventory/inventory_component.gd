class_name InventoryComponent
extends Node2D

@export var HandSprite : Sprite2D
@export var QuantityLabel : Label

var inventorys: Array[Inventory]
var max_slots : int

var dragging := false
var stack_dragging : Stack = null
var default_pickup_amount = -1


# When Dragging puts hand onto mouse
func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position()
		


# Puts inventory in group, idk about this though
func attach_inventory(new_inventory: Inventory) -> void:
	inventorys.append(new_inventory)
	
	if default_pickup_amount != -1:
		default_pickup_amount = min(new_inventory.max_quantity,\
			default_pickup_amount)
	else:
		default_pickup_amount = new_inventory.max_quantity
	
	for slot in new_inventory.item_slots:
		slot.gui_input.connect(slot_clicked.bind(new_inventory, slot))


# Updates the hand to represent current dragging stack
func update_hand() -> void:
	HandSprite.texture = stack_dragging.get_sprite()
	QuantityLabel.text = stack_dragging.get_quantity_label()
	
	if stack_dragging.isEmpty:
		dragging = false
		stack_dragging.queue_free()
		stack_dragging = null


func remove_from_stack(stack: Stack, amount_to_remove: int) -> Stack:
	if amount_to_remove > stack.quantity:
		amount_to_remove = stack.quantity
	
	var remove_stack := Stack.new(amount_to_remove).clone_type(stack)
	stack.quantity -= amount_to_remove
	
	return remove_stack


func pickup_stack(slot: ItemSlot, \
		amount_to_pickup: int = default_pickup_amount) -> void:
	dragging = true
	if amount_to_pickup <= -1:
		stack_dragging = slot.stack
		slot.stack = Stack.new(0)
	else:
		stack_dragging = remove_from_stack(slot.stack, amount_to_pickup)
	
	update_hand()


func place_stack(inventory: Inventory, slot: ItemSlot) -> void:
	stack_dragging = inventory.add_stack_to_slot(stack_dragging, slot)
	update_hand()

func swap_held_stack(slot: ItemSlot) -> void:
	var swap_temp := stack_dragging
	stack_dragging = slot.stack
	slot.stack = swap_temp
	update_hand()

# Called when player clicks on item slot
func slot_clicked(event: InputEvent, inventory: Inventory, slot: ItemSlot) -> void:
	if event.is_action_pressed("grab_inventory_item"):
		print("clicked")
		# Nothing currently held
		if !dragging:
			pickup_stack(slot)
		# Add same stack to each other
		elif slot.stack.item_name == stack_dragging.item_name:
			place_stack(inventory, slot)
		# Swap held stack with another
		else:
			print("adsa")
			swap_held_stack(slot)
	
	elif event.is_action_pressed("place_inventory_item"):
		if dragging:
			inventory.add_some_to_slot(stack_dragging, slot, 1)
			update_hand()

func drop_held() -> Stack:
	if stack_dragging != null:
		# Dropping stuff
		var s = stack_dragging
		stack_dragging = Stack.new(0)
		update_hand()
		return s
	return null

# Called when background is clicked
# Care as can active in gaps between slots
func click_background(event: InputEvent) -> void:
	if event.is_action_pressed("grab_inventory_item"):
		drop_held()
