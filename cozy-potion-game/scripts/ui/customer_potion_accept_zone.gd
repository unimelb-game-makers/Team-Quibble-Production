class_name CustomerPotionAcceptZone extends Control

signal potion_accepted(potion: Potion)
signal other_accepted(other: Resource)

@export var draggable_acceptor_compoment: DraggableAcceptorComponent
func _ready() -> void:
	draggable_acceptor_compoment.accepted_draggable.connect(_on_draggable_accepted)

## Called when a draggable is dropped on the acceptor. emits either
## of this nodes signals with the parameter of the dropped item
## if available.
func _on_draggable_accepted(control: Control) -> void:
	if not control is ItemSlot or not is_instance_valid(control.stack):
		DraggableComponent.get_draggable_component(control).return_to_previous()
		other_accepted.emit(null)
		return
	
	var stack: Stack = control.stack
	
	if not stack.item is Potion:
		DraggableComponent.get_draggable_component(control).return_to_previous()
		other_accepted.emit(stack.item)
		return 
	
	potion_accepted.emit(stack.item)
	
