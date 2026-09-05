## add as child of a ui element that you want to be draggable
class_name DraggableComponent extends Node
#this code and the coupled DraggableAcceptor make liberal use of get_parent()
#which is generally bad when overused but there is no other oppurtunity

#if you encounter bugs to do with positioning while dragging, consider
#changing this code to use offset_transform


static var dragged_control: Control
static var pending_parent: Control

var previous_parent: Control

var being_dragged: bool = false
var my_control: Control

#use these in the control that uses this component if you want
#functionality when dragging or dropping
signal draggable_dropped
signal draggable_accepted
signal draggable_picked_up

func _ready() -> void:
	assert(get_parent() is Control, "draggable component not child of control")
	my_control = get_parent()
	
func _process(_delta: float) -> void:
	if dragged_control == my_control:
		move_to_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("LMB"):
		being_dragged = false
		if dragged_control == my_control:
			dragged_control = null
			#if we don't have a parent waiting to pick up,
			#return to previous owner
			print_debug(pending_parent)
			if not pending_parent or pending_parent == my_control.get_parent():
				return_to_previous()
			else:
				parent_to_acceptor()


	if !event.is_action_pressed("LMB"):
		return

	if !my_control.get_global_rect().has_point(my_control.get_global_mouse_position()):
		return

	if dragged_control:
		return

	assign_to_mouse()

func assign_to_mouse() -> void:
	draggable_picked_up.emit()
	dragged_control = my_control
	previous_parent = my_control.get_parent()
	being_dragged = true

func move_to_mouse() -> void:
	my_control.global_position = my_control.get_global_mouse_position() - my_control.get_global_rect().size/2

# Called when dragged to ensure returns to orignal owner
func return_to_previous() -> void:
	draggable_dropped.emit()
	being_dragged = false
	my_control.reparent(previous_parent)
	my_control.position = Vector2.ZERO
	if previous_parent is Container:
		previous_parent.queue_sort()

func parent_to_acceptor() -> void:
	if not pending_parent:
		return_to_previous()
	if get_acceptor(pending_parent):
		get_acceptor(pending_parent).accepted_draggable.emit()
	my_control.reparent(pending_parent)
	pending_parent = null
	draggable_accepted.emit()
	

func get_acceptor(node: Node) -> DraggableAcceptorComponent:
	for child in node.get_children():
		if child is DraggableAcceptorComponent:
			return child
	
	return null
