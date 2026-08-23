class_name Minigame extends Node2D

signal minigame_won

func win_minigame() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	minigame_won.emit()
