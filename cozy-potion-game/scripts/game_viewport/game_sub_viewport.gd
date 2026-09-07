class_name GameSubviewport extends SubViewport

func _ready() -> void:
	var base_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var base_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var base_size = Vector2i(base_width, base_height)
	assert(size == base_size, "The game's window size is not the same size as the subviewport.
	This might cause an issue. I don't know.")
