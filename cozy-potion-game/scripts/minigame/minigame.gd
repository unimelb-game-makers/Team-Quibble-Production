class_name Minigame extends CanvasLayer

signal minigame_won

signal ingredient_processed(_processed_ingredient: Stack)

var ingredient: Stack

func win_minigame() -> void:
	ingredient_processed.emit(ingredient)
	process_mode = Node.PROCESS_MODE_DISABLED
	minigame_won.emit()

func set_ingredient(_new_ingredient: Stack) -> void:
	apply_ingredient(_new_ingredient)
	## TODO: this should be the processed ingredient
	ingredient = _new_ingredient

func apply_ingredient(_new_ingredient: Stack) -> void:
	## Applies the coloring and textures
	pass
