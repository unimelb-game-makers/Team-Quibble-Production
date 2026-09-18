class_name CustomerPotionAcceptZone extends Control

signal potion_accepted(potion: Potion)
signal other_accepted(other: Resource)

@export var draggable_acceptor_compoment: DraggableAcceptorComponent


## Called when a draggable is dropped on the acceptor. emits either
## of this nodes signals with the parameter of the dropped item
## if available.
func _on_draggable_dropped(control: Control):
	if not control is ItemSlot or not is_instance_valid(control.stack):
		other_accepted.emit(null)
		return
	
	var stack: Stack = control.stack
	
	if not stack.item is Potion:
		other_accepted.emit(stack.item)
		return 
	
	potion_accepted.emit(stack.item)
	
