class_name Minigame extends CanvasLayer

signal minigame_won

@export var acceptor: DraggableAcceptorComponent
@export var draggable_hint_rect: ColorRect
@export var process: Alchemy.ProcessID
#emitted when an item is added to the minigame.
# this is usually done by dragging from the hotbar
#most minigames should not start until this is done
signal ingredient_added(stack: Stack)
signal ingredient_processed(_processed_ingredient: Stack)

var input_ingredients: Array[Stack]
var output_ingredient: Stack = Stack.new()

@onready var player: WorldPlayer = get_tree().get_first_node_in_group(Utils.Group.GROUP_PLAYER)

func _ready() -> void:
	acceptor.accepted_draggable.connect(emit_ingredient_added)

func win_minigame() -> void:
	for stack in input_ingredients:
		var processed_stack = process_ingredient(stack)
		ingredient_processed.emit(processed_stack)
		player.inventory().blind_add_stack(processed_stack)

	process_mode = Node.PROCESS_MODE_DISABLED
	input_ingredients.clear()
	minigame_won.emit()

func close_minigame() -> void:
	for stack in input_ingredients:
		player.inventory().blind_add_stack(stack)
	input_ingredients.clear()

func set_ingredient_list(_new_ingredient_list: Array[Stack]) -> void:
	pass

func process_ingredient(input_stack: Stack) -> Stack:
	input_stack.item = input_stack.item.copy()
	input_stack.item.apply_process(process)
	return input_stack

#this is one way of connecting the ingredient accepted signal
# from the subviewportcontainer above this to the minigame
func emit_ingredient_added(draggable: Control):
	if draggable_hint_rect:
		draggable_hint_rect.hide()
	if draggable is ItemHolder:
		input_ingredients.append(draggable.get_item_stack())
		ingredient_added.emit(draggable.get_item_stack())
	else:
		assert(false, "added non ingredient")
	draggable.queue_free()


# Copy of above for clickable
func emit_clickable_added(clickable: ClickableComponent):
	if draggable_hint_rect:
		draggable_hint_rect.hide()
	if clickable.my_control is ItemHolder:
		ingredient_added.emit(clickable.my_control.get_item_stack())
	else:
		assert(false," added non ingredient")
	
	clickable.my_control.queue_free()
