extends Node


func _ready() -> void:
	if OS.has_feature("standalone"):
		unpause()
	else:
		pause()

func pause() -> void:
	music.paused = true

func unpause() -> void:
	music.paused = false
