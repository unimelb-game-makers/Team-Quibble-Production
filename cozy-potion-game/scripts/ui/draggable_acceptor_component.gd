#add as a child of a control that you want to have child draggables
# will push a warning if this node isn't a container.
class_name DraggableAcceptorComponent extends Node

var my_control: Control

func _ready() -> void:
	if not get_parent() is Container:
		push_warning("DraggableAcceptorComponent child of non-container")
	my_control = get_parent()

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return
	
	if not DraggableComponent.dragged_control:
		return
	
	var intersecting_mouse: bool = \
	my_control.get_global_rect().has_point(my_control.get_global_mouse_position())
	

	if intersecting_mouse and DraggableComponent.pending_parent != my_control:
		DraggableComponent.pending_parent = my_control
	
	if not intersecting_mouse and DraggableComponent.pending_parent == my_control:
		DraggableComponent.pending_parent == null
