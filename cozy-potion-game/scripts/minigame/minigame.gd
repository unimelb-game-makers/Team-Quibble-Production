class_name Minigame extends CanvasLayer

signal minigame_won

#emitted when an item is added to the minigame.
# this is usually done by dragging from the hotbar
#most minigames should not start until this is done
signal ingredient_added(stack: Stack)
signal ingredient_processed(_processed_ingredient: Stack)

var input_ingredients: Array[Stack]
var output_ingredient: Stack
var hotbar: Inventory
var input_index: int

func win_minigame() -> void:
	ingredient_processed.emit(output_ingredient)
	process_mode = Node.PROCESS_MODE_DISABLED
	
	# Returns hotbar, mutaliate before this
	minigame_won.emit(hotbar)

func set_ingredient_list(_new_ingredient_list: Array[Stack]) -> void:
	pass

func set_hotbar(new_hotbar: Inventory, new_input_index: int) -> void:
	hotbar = new_hotbar
	input_index = new_input_index

func set_ingredient(_new_ingredient: Stack) -> void:
	_apply_ingredient(_new_ingredient)
	input_ingredients.append(_new_ingredient)
	## TODO: this should be the processed ingredient
	output_ingredient = _new_ingredient

## private function; this gets overwritten for each child
func _apply_ingredient(_new_ingredient: Stack) -> void:
	## Applies the coloring and textures
	pass
	
#this is one way of connecting the ingredient accepted signal
# from the subviewportcontainer above this to the minigame
func emit_ingredient_added(draggable: Control):
	ingredient_added.emit(Stack.new())
