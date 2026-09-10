class_name Minigame extends CanvasLayer

signal minigame_won

signal ingredient_processed(_processed_ingredient: Stack)

var ingredient: Stack
var hotbar: Inventory
var input_index: int


func win_minigame() -> void:
	ingredient_processed.emit(ingredient)
	process_mode = Node.PROCESS_MODE_DISABLED
	
	# Returns hotbar, mutaliate before this
	minigame_won.emit(hotbar)

func set_ingredient_list(_new_ingredient_list: Array[Stack]) -> void:
	pass

func set_hotbar(new_hotbar: Inventory, new_input_index: int) -> void:
	hotbar = new_hotbar
	input_index = new_input_index
	set_ingredient(hotbar.item_slots[input_index].stack)

func set_ingredient(_new_ingredient: Stack) -> void:
	_apply_ingredient(_new_ingredient)
	## TODO: this should be the processed ingredient
	ingredient = _new_ingredient

## private function; this gets overwritten for each child
func _apply_ingredient(_new_ingredient: Stack) -> void:
	## Applies the coloring and textures
	pass
