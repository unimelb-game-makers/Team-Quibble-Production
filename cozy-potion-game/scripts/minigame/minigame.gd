class_name Minigame extends CanvasLayer

signal minigame_won

signal ingredient_processed(_processed_ingredient: Stack)

var ingredient: Stack

func win_minigame() -> void:
	ingredient_processed.emit(ingredient)
	process_mode = Node.PROCESS_MODE_DISABLED
	minigame_won.emit()

func set_ingredient_list(_new_ingredient_list: Array[Stack]) -> void:
	pass

func set_ingredient(_new_ingredient: Stack) -> void:
	_apply_ingredient(_new_ingredient)
	## TODO: this should be the processed ingredient
	ingredient = _new_ingredient

## private function; this gets overwritten for each child
func _apply_ingredient(_new_ingredient: Stack) -> void:
	## Applies the coloring and textures
	pass
