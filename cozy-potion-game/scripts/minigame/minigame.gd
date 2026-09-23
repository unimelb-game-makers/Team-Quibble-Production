class_name Minigame extends CanvasLayer

signal minigame_won

@export var acceptor: ClickableAcceptorComponent
@export var draggable_hint_rect: ColorRect
#emitted when an item is added to the minigame.
# this is usually done by dragging from the hotbar
#most minigames should not start until this is done
signal ingredient_added(stack: Stack)
signal ingredient_processed(_processed_ingredient: Stack)

var input_ingredients: Array[Stack]
var output_ingredient: Stack

var player: WorldPlayer

func _ready() -> void:
	acceptor.accepted_draggable.connect(emit_ingredient_added)

func win_minigame() -> void:
	print_debug("created a %s and added to hotbar" % output_ingredient.item.ingredient_name)
	ingredient_processed.emit(output_ingredient)
	process_mode = Node.PROCESS_MODE_DISABLED
	
	player = get_tree().get_first_node_in_group(Utils.Group.GROUP_PLAYER)
	player.hotbar_display.inventory.blind_add_stack(output_ingredient)
	minigame_won.emit()

func set_ingredient_list(_new_ingredient_list: Array[Stack]) -> void:
	pass

#this is one way of connecting the ingredient accepted signal
# from the subviewportcontainer above this to the minigame
func emit_ingredient_added(draggable: Control):
	draggable.queue_free()
	if draggable_hint_rect:
		draggable_hint_rect.hide()
	if draggable is ItemHolder:
		ingredient_added.emit(draggable.get_stack())
	else:
		assert(false," added non ingredient")


# Copy of above for clickable
func emit_clickable_added(clickable: ClickableComponent):
	if draggable_hint_rect:
		draggable_hint_rect.hide()
	if clickable.my_control is ItemHolder:
		ingredient_added.emit(clickable.my_control.get_item_stack())
	else:
		assert(false," added non ingredient")
	
	clickable.my_control.queue_free()
