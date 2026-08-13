class_name PlaceBox
extends Area2D

@export var home: Container

var dragbox : DragBox

signal draggable_placed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(dragbox_entered)
	area_exited.connect(dragbox_exited)
	input_event.connect(release_box)

func get_home() -> Container:
	return home

func dragbox_entered(area: Area2D) -> void:
	if area is DragBox:
		dragbox = area


func dragbox_exited(area: Area2D) -> void:
	if area == dragbox and Input.is_action_pressed("LMB"):
		dragbox = null


func release_box(_viewport: Viewport, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_released("LMB"):
		if dragbox != null:
			dragbox.place_in(self)


func placed_dragbox(dragbox_emit: DragBox) -> void:
	draggable_placed.emit(dragbox_emit)
