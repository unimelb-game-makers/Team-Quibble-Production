extends Node2D
class_name Indicator

@export var node: Node3D

func set_pivot():
	global_position = get_viewport().get_camera_3d().unproject_position(node.global_position)
	pass

func _process(delta: float) -> void:
	set_pivot()
	print("here")
