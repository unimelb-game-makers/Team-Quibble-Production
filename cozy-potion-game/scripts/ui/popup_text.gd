extends Node2D
class_name PopupText

@onready var label = $Label

var pivot: Node3D

func initialize(_pivot: Node3D, text: String):
	pivot = _pivot
	label.text = text

func follow_pivot():
	global_position = get_viewport().get_camera_3d().unproject_position(pivot.position)

func _process(delta: float) -> void:
	follow_pivot()
