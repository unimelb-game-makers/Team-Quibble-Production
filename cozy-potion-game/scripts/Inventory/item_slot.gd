class_name ItemSlot
extends PanelContainer

# Emitted every frame if cursor inside slot
signal hovering

@export var acceptor : ClickableAcceptorComponent

var item_holder : ItemHolder = null
var ishovering := false
var trash_collector : Control = null
var max_quantity: int = 999


static func get_scene() -> PackedScene:
	return preload("uid://bcqi5ykyush3i")


func _ready() -> void:
	acceptor.request_left_placement.connect(placed_holder_clickable)
	acceptor.request_right_placement.connect(placed_RMB_clickable)


# Exists so panel can be filter Ignore, emulates mouse_exited/entered
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		emulate_mouse_inside()


# If cursor inside emits hovering signal, emits mouse_exited if cursor leaves
func emulate_mouse_inside() -> void:
	var intersecting_mouse: bool = \
		get_global_rect().has_point(get_global_mouse_position())
	if intersecting_mouse:
		# if hovering emits signal
		hovering.emit()
		ishovering = true
	elif ishovering:
		# if was hovering and no longer is emits mouse_existed signal
		ishovering = false
		mouse_exited.emit()

const ITEM_HOLDER = preload("res://scenes/prefabs/inventory/item_holder_scene.tscn")

# Creates new ItemHolder from stack to set as holder
func set_stack(stack:Stack) -> void:
	# Kills pre existing holder if there
	if item_holder != null:
		item_holder.queue_free()
	
	# Creates new holder from stack
	var new_item_holder = ITEM_HOLDER.instantiate()
	add_child(new_item_holder)
	
	set_item_holder(new_item_holder)
	new_item_holder.stack = stack
	
	# Hatred is friend of this line of code
	new_item_holder.clickable_component.trash_collector = trash_collector


# Adds ItemHolder that does not exist in scene yet, as child and stores in slot
func set_item_holder(holder : ItemHolder) -> void:
	if item_holder == null:
		item_holder = holder
		holder.clickable_component.request_pickup.connect(pickup_request)


func pickup_request() -> void:
	var new_item_holder :ItemHolder= ITEM_HOLDER.instantiate()
	add_child(new_item_holder)
	new_item_holder.stack = item_holder.take_from_stack(1)
	
	# Hatred is friend of this line of code
	new_item_holder.clickable_component.trash_collector = trash_collector
	new_item_holder.clickable_component.assign_to_mouse()
	
	if item_holder.stack.isEmpty:
		item_holder.queue_free()
		item_holder = null


# Called to place ItemHolder in slot
func placed_holder_clickable(placed_clickable : ClickableComponent) -> void:
	var placed = placed_clickable.my_control
	if placed is ItemHolder:
		if item_holder == null:
			set_stack(placed.take_from_stack(max_quantity))
			if placed.stack.isEmpty:
				placed_clickable.stop_dragging()
				placed.queue_free()
		elif item_holder.get_item_stack().compare_stacks(placed.get_item_stack()):
			placed.stack = add_to_stack(placed.get_item_stack())
			if placed.stack.isEmpty:
				placed_clickable.stop_dragging()
				placed.queue_free()
		else:
			# Does not consider max quantity here, idk implementation side whats wanted
			placed_clickable.place_clickable(self)
			placed_clickable.trash_collector = trash_collector
			item_holder.clickable_component.assign_to_mouse()
			item_holder.clickable_component.request_pickup.disconnect(pickup_request)
			item_holder = placed
			placed.clickable_component.request_pickup.connect(pickup_request)


func placed_RMB_clickable(placed_clickable : ClickableComponent) -> void:
	var placed = placed_clickable.my_control
	if placed is ItemHolder:
		if item_holder == null:
			set_stack(placed.take_from_stack(1))
		elif item_holder.get_item_stack().compare_stacks(placed.get_item_stack()):
			var leftovers := add_to_stack(placed.take_from_stack(1))
			if not leftovers.isEmpty:
				# real bad
				placed.stack.quantity += leftovers.quantity
		
		if placed.stack.isEmpty:
			placed_clickable.stop_dragging()
			placed.queue_free()


# Returns stack held by ItemHolder, gives empty if no ItemHolder
func get_item_stack() -> Stack:
	if item_holder != null:
		return item_holder.stack
	return Stack.new()


# Adds stack to another stack in a slot,
# Returns leftover of stack
func add_to_stack(new_item: Stack) -> Stack:
	# Make sure valid to add item to slot 
	# (this creates weird redundancy thats semi nesscary, 
	# but like want to prevent misuse as well) 
	if get_item_stack().isEmpty:
		set_stack(Stack.new(0, new_item.item))
	elif not get_item_stack().compare_stacks(new_item):
		return new_item

	# Adds as much as can be added to stack
	var add_to_stack : int = \
		min(max_quantity - get_item_stack().quantity, new_item.quantity)
	item_holder.stack.quantity += add_to_stack
	new_item.quantity -= add_to_stack
	
	return new_item
