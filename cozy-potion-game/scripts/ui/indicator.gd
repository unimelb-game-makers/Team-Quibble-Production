extends Node2D
class_name Indicator

var pivot_pos: Vector3

func _ready() -> void:
	var tw: Tween = get_tree().create_tween()
	tw.set_loops(-1)
	tw.tween_property($PanelContainer, "offset_transform_position:y", -30, 1).set_trans(Tween.TRANS_QUAD)
	tw.tween_property($PanelContainer, "offset_transform_position:y", 0, 1).set_trans(Tween.TRANS_QUAD)

func set_pivot(pos: Vector3):
	pivot_pos = pos

func _process(delta: float) -> void:
	global_position = get_viewport().get_camera_3d().unproject_position(pivot_pos)
