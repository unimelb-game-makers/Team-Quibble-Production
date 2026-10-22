class_name ItemSlot
extends PanelContainer

# Emitted every frame if cursor inside slot
signal hovering

const ITEM_HOLDER = preload("uid://80sdcv4hsqa1")

var item_holder : ItemHolder = null
var ishovering := false
var max_quantity: int = 999
var blacklist: Array[Resource]

var max_pickup: int = 1

@onready var drag_acceptor: DraggableAcceptorComponent = $DraggableAcceptorComponent

static func get_scene() -> PackedScene:
	return preload("uid://bcqi5ykyush3i")

func _ready() -> void:
	drag_acceptor.accepted_draggable.connect(set_item_holder)
	pass

# Exists so panel can be filter Ignore, emulates mouse_exited/entered
func _input(event: InputEvent) -> void:
	# Previously this would only emit motion but not justs emits if cursor hovering
	var hovering = emulate_mouse_inside()
	
	if not hovering and Input.is_action_just_pressed("RMB"):
		if item_holder:
			item_holder.highlight_turn_off()

func add_blacklist(_list: Array) -> void:
	blacklist = _list
	drag_acceptor.blacklist = _list

# If cursor inside emits hovering signal, emits mouse_exited if cursor leaves
func emulate_mouse_inside() -> bool:
	var intersecting_mouse: bool = \
		get_global_rect().has_point(get_global_mouse_position())
	if intersecting_mouse:
		# if hovering emits signal
		hovering.emit()
		ishovering = true
		if item_holder:
			item_holder.highlight_turn_on()
	elif ishovering:
		# if was hovering and no longer is emits mouse_existed signal
		ishovering = false
		if item_holder:
			item_holder.highlight_turn_off()
		mouse_exited.emit()
	
	return intersecting_mouse

func create_holder_as_child(stack : Stack) -> ItemHolder:
	var new_item_holder = ITEM_HOLDER.instantiate()
	add_child(new_item_holder)
	new_item_holder.stack = stack
	
	return new_item_holder


# Creates new ItemHolder from stack to set as holder
func set_stack(stack:Stack) -> void:
	# Creates new holder from stack
	var holder := create_holder_as_child(stack)
	set_item_holder(holder)


# Adds ItemHolder that does not exist in scene yet, as child and stores in slot
func set_item_holder(holder : ItemHolder) -> void:
	if item_holder == null:
		item_holder = holder
		drag_acceptor.accepting_items = false
		item_holder.draggable_component.draggable_accepted.connect(remove_holder)

func remove_holder() -> void:
	item_holder.draggable_component.draggable_accepted.disconnect(remove_holder)
	#item_holder = null
	#drag_acceptor.accepting_items = true
	
	# Remove HERE if you want to remove 1 item taking from stack
	var previous_quant := item_holder.get_item_stack().quantity
	if previous_quant <= 1:
		item_holder = null
		drag_acceptor.accepting_items = true
	else:
		item_holder.get_item_stack().quantity = 1
		set_stack(Stack.new(previous_quant - 1).
			clone_type(item_holder.get_item_stack()))

func is_item_blacklist(_item: Resource) -> bool:
	if blacklist.size() == 0:
		return false

	breakpoint

	for item in blacklist:
		if item.resource_path == _item.resource_path:
			return true
	
	return false

# NOT USED BELOW


func disconnect_holder() -> void:
	if item_holder != null:
		item_holder.draggable_component.drag_request_pick_up\
			.disconnect(requested_pickup)
		item_holder = null


func requested_pickup(requesting_draggable : DraggableComponent) -> void:
	if true:
		item_holder.highlight_turn_off()
		requesting_draggable.assign_to_mouse()
	pass

# NOT USED ABOVE



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
