class_name PlaceBox
extends Area2D

# Works in conjunction with drag_box

# Container to put draggables in
@export var home: Container

# Connected dragBox, used to store current dragbox ontop of self
var dragbox : DragBox

# Called when draggable dropped
signal draggable_placed


func _ready() -> void:
	area_entered.connect(dragbox_entered)
	area_exited.connect(dragbox_exited)
	input_event.connect(release_box)

# Gets home container of placebox
func get_home() -> Container:
	return home

# Stores dragbox that recently entered area
func dragbox_entered(area: Area2D) -> void:
	if area is DragBox:
		dragbox = area

# Forgets most recent dragbox if left area
func dragbox_exited(area: Area2D) -> void:
	if area == dragbox and Input.is_action_pressed("LMB"):
		dragbox = null

# Called when dragbox is attempting to place in self
func release_box(_viewport: Viewport, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_released("LMB"):
		if dragbox != null:
			dragbox.place_in(self)

# Called by DragBox to say something was placed in placeBox
func placed_dragbox(dragbox_emit: DragBox) -> void:
	draggable_placed.emit(dragbox_emit)
