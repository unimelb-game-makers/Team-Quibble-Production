#add as a child of a control that you want to have child draggables
# will push a warning if this node isn't a container.
class_name ClickableAcceptorComponent extends Node

var my_placement: Control
var accepting_items: bool = true

var mouse_intersecting : bool = false

#use this in the control that uses this if you want
signal request_left_placement(draggable: Control)
signal request_right_placement(draggable: Control)

func _ready() -> void:
	if not get_parent() is Container:
		push_warning("DraggableAcceptorComponent child of non-container")
	my_placement = get_parent()


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		#print_debug(1)
		return
	
	if not ClickableComponent.dragged_control:
		#print_debug(2)
		return
	
	if not my_placement.is_visible_in_tree():
		#print_debug(3)
		return

	if not accepting_items:
		return

	
	var intersecting_mouse: bool = \
	my_placement.get_global_rect().has_point(my_placement.get_global_mouse_position())

	if intersecting_mouse and ClickableComponent.pending_acceptor != self:
		ClickableComponent.pending_acceptor = self
	
	if not intersecting_mouse and ClickableComponent.pending_acceptor == self:
		ClickableComponent.pending_acceptor = null


func emit_request_left_placement(draggable: ClickableComponent) -> void:
	if accepting_items:
		request_left_placement.emit(draggable)


func emit_request_right_placement(draggable: ClickableComponent) -> void:
	if accepting_items:
		request_right_placement.emit(draggable)
