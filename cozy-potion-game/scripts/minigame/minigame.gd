class_name Minigame extends CanvasLayer

signal minigame_won

@export var acceptor: DraggableAcceptorComponent
@export var draggable_hint_rect: ColorRect
#emitted when an item is added to the minigame.
# this is usually done by dragging from the hotbar
#most minigames should not start until this is done
signal ingredient_added(stack: Stack)
signal ingredient_processed(_processed_ingredient: Stack)

var input_ingredients: Array[Stack]
var output_ingredient: Stack
var hotbar: Inventory
var input_index: int

func _ready() -> void:
	acceptor.accepted_draggable.connect(emit_ingredient_added)

func win_minigame() -> void:
	print_debug("created a %s and added to hotbar" % output_ingredient.item.ingredient_name)
	ingredient_processed.emit(output_ingredient)
	process_mode = Node.PROCESS_MODE_DISABLED
	
	# Returns hotbar, mutaliate before this
	minigame_won.emit(hotbar)

func set_ingredient_list(_new_ingredient_list: Array[Stack]) -> void:
	pass

func set_hotbar(new_hotbar: Inventory, new_input_index: int) -> void:
	hotbar = new_hotbar
	input_index = new_input_index

#this is one way of connecting the ingredient accepted signal
# from the subviewportcontainer above this to the minigame
func emit_ingredient_added(draggable: Control):
	draggable.queue_free()
	if draggable_hint_rect:
		draggable_hint_rect.hide()
	if draggable is ItemSlot:
		ingredient_added.emit(draggable.stack)
	else:
		assert(false," added non ingredient")
