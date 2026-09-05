##a class that does nothing but have an interacted signal that is emitted
## from it by the player and is listened to by certain objects which then 
## perform logic.
class_name Interactable extends Area3D

signal interacted

const INTERACTABLE_LAYER: int = 21

var popup: PopupText = null

func _ready() -> void:
	set_collision_layer_value(INTERACTABLE_LAYER, true)
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)

## Handle when the player enters the box
func _body_entered(body: Node3D):
	if body is WorldPlayer:
		popup = Utils.popup_manager.spawn_popup(self)
## When player leaves box
func _body_exited(body: Node3D):
	if body is WorldPlayer and popup:
		popup.queue_free()
