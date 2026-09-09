extends Node2D
class_name Indicator

var pivot_pos: Vector3

func set_pivot(pos: Vector3):
	pivot_pos = pos

func _process(delta: float) -> void:
	global_position = get_viewport().get_camera_3d().unproject_position(pivot_pos)
