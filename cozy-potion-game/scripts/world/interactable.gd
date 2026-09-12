##a class that does nothing but have an interacted signal that is emitted
## from it by the player and is listened to by certain objects which then 
## perform logic.
class_name Interactable extends Area3D

signal interacted

const INTERACTABLE_LAYER: int = 21

var popup: PopupText = null

func _ready() -> void:
	set_collision_layer_value(INTERACTABLE_LAYER, true)
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)

func interact():
	print_debug(1)
	interacted.emit()
	if popup: 
		popup.queue_free()

## Handle when an area enters the box
func _area_entered(area: Area3D):
	if area is PlayerInteractableDetector:
		popup = Utils.popup_manager.spawn_popup(self)

## When area leaves box
func _area_exited(area: Area3D):
	if area is PlayerInteractableDetector and popup:
		popup.queue_free()
