class_name PlaceBox
extends Area2D

@export var home: Container

signal draggable_placed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func get_home() -> Container:
	return home


func placed_dragbox(dragbox: DragBox) -> void:
	draggable_placed.emit(dragbox)
