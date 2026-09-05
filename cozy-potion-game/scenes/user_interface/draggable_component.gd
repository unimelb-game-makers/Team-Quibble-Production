## add as child of a ui element that you want to be draggable
class_name DraggableComponent extends Node

static var dragged_control: Control
static var pending_parent: Control

var previous_parent: Control

var being_dragged: bool = false
var my_control: Control

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
				return_to_box()
			else:
				my_control.reparent(pending_parent)

	if !event.is_action_pressed("LMB"):
		return

	if !my_control.get_global_rect().has_point(my_control.get_global_mouse_position()):
		return

	if dragged_control:
		return

	assign_to_mouse()

func assign_to_mouse() -> void:
	dragged_control = my_control
	previous_parent = my_control.get_parent()
	being_dragged = true

func move_to_mouse() -> void:
	my_control.global_position = my_control.get_global_mouse_position()

# Called when dragged to ensure returns to orignal owner
func return_to_box() -> void:
	print_debug(1)
	being_dragged = false
	my_control.reparent(previous_parent)
	my_control.position = Vector2.ZERO
	if previous_parent is Container:
		previous_parent.queue_sort()
