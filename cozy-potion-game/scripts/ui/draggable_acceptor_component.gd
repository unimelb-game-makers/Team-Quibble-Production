#add as a child of a control that you want to have child draggables
# will push a warning if this node isn't a container.
class_name DraggableAcceptorComponent extends Node

var my_control: Control

#use this in the control that uses this if you want
signal accepted_draggable(draggable: Control)

func _ready() -> void:
	if not get_parent() is Container:
		push_warning("DraggableAcceptorComponent child of non-container")
	my_control = get_parent()

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		#print_debug(1)
		return
	
	if not DraggableComponent.dragged_control:
		#print_debug(2)
		return
	
	if not my_control.is_visible_in_tree():
		#print_debug(3)
		return

		
	var intersecting_mouse: bool = \
	my_control.get_global_rect().has_point(get_viewport().get_mouse_position())
	#print_debug(get_viewport().get_mouse_position())

	if intersecting_mouse and DraggableComponent.pending_parent != my_control:
		DraggableComponent.pending_parent = my_control
	
	if not intersecting_mouse and DraggableComponent.pending_parent == my_control:
		DraggableComponent.pending_parent == null

#hack. Please let me be done with this
func emit_accepted(draggable: Control):
	print_debug(1397)
	accepted_draggable.emit(draggable)
