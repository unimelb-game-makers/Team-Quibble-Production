class_name DraggableUI
extends Panel

static var node_being_dragged: DraggableUI

@onready var container_parent := get_parent() 
@onready var label: Label = $Label

var being_dragged: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if being_dragged:
		move_to_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("LMB"):
		if node_being_dragged == self:
			node_being_dragged = null
			return_to_box()

	if !event.is_action_pressed("LMB"):
		return

	if !get_global_rect().has_point(get_global_mouse_position()):
		return

	if node_being_dragged:
		return

	assign_to_mouse()

func assign_to_mouse() -> void:
	node_being_dragged = self
	being_dragged = true

func move_to_mouse() -> void:
	global_position = get_global_mouse_position()

# Called when dragged to ensure returns to orignal owner
func return_to_box() -> void:
	being_dragged = false
	reparent(container_parent)
	if container_parent is Container:
		container_parent.queue_sort()

# TODO: Move all code below to a different script that is attached to this node.

var ingredient_name: String
var ingredient_resource: PotionIngredient

func set_resource(_ingredient_resource: PotionIngredient) -> void:
	ingredient_resource = _ingredient_resource
	ingredient_name = ingredient_resource.name
	label.text = ingredient_name

func get_info() -> String:
	return ingredient_name
