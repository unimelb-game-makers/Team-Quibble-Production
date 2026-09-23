class_name ItemSlot
extends PanelContainer

# Emitted every frame if cursor inside slot
signal hovering

@export var acceptor : DraggableAcceptorComponent

var item_holder : ItemHolder = null
var ishovering := false


static func get_scene() -> PackedScene:
	return preload("uid://bcqi5ykyush3i")


func _ready() -> void:
	acceptor.accepted_draggable.connect(placed_item_holder)


# Exists so panel can be filter Ignore, emulates mouse_exited/entered
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		emulate_mouse_inside()


# If cursor inside emits hovering signal, emits mouse_exited if cursor leaves
func emulate_mouse_inside() -> void:
	var intersecting_mouse: bool = \
		get_global_rect().has_point(get_global_mouse_position())
	if intersecting_mouse:
		# if hovering emits signal
		hovering.emit()
		ishovering = true
	elif ishovering:
		# if was hovering and no longer is emits mouse_existed signal
		ishovering = false
		mouse_exited.emit()

const ITEM_HOLDER = preload("uid://80sdcv4hsqa1")

# Creates new ItemHolder from stack to set as holder
func set_stack(stack:Stack) -> void:
	# Kills pre existing holder if there
	if item_holder != null:
		item_holder.queue_free()
	# Creates new holder from stack
	var new_item_holder = ITEM_HOLDER.instantiate()
	set_item_holder(new_item_holder)
	new_item_holder.stack = stack


# Adds ItemHolder that does not exist in scene yet, as child and stores in slot
func set_item_holder(holder : ItemHolder) -> void:
	if item_holder == null:
		add_child(holder)
		placed_item_holder(holder)


# Called when held ItemHolder signals that is had been removed from slot
func removed_item_holder() -> void:
	item_holder.draggable_component.draggable_accepted.\
		disconnect(removed_item_holder)
	item_holder = null
	acceptor.accepting_items = true


# Called to place ItemHolder in slot
func placed_item_holder(placed_control : Control) -> void:
	if placed_control is ItemHolder:
		item_holder = placed_control
		acceptor.accepting_items = false
		placed_control.draggable_component.draggable_accepted.connect\
			.call_deferred(removed_item_holder)


# Returns stack held by ItemHolder, gives empty if no ItemHolder
func get_stack() -> Stack:
	if item_holder != null:
		return item_holder.stack
	return Stack.new()
