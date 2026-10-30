extends TextureRect



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# print_debug(1)
	offset_transform_position.y = cos(Time.get_ticks_msec() / 1000.0) * 10
