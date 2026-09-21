class_name ItemSlot
extends PanelContainer

@export var acceptor : DraggableAcceptorComponent

var item_holder : ItemHolder = null

var hovering := false

static func get_scene() -> PackedScene:
	return preload("uid://bcqi5ykyush3i")


func _ready() -> void:
	acceptor.accepted_draggable.connect(placed_item_holder)


# Exists so panel can be Ignore, emulates mouse_exited/entered
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		emulate_mouse_inside()


func emulate_mouse_inside() -> void:
	var intersecting_mouse: bool = \
		get_global_rect().has_point(get_global_mouse_position())
	if intersecting_mouse != hovering:
		if hovering:
			mouse_exited.emit()
		else:
			mouse_entered.emit()
		hovering = not hovering


func set_item_holder(holder : ItemHolder) -> void:
	if item_holder == null:
		add_child(holder)
		placed_item_holder(holder)


func removed_item_holder() -> void:
	item_holder.draggable_component.draggable_accepted.disconnect(removed_item_holder)
	item_holder = null
	acceptor.accepting_items = true


func placed_item_holder(placed_control : Control) -> void:
	if placed_control is ItemHolder:
		item_holder = placed_control
		acceptor.accepting_items = false
		mouse_entered.emit() #i dont like but makes hover appear
		placed_control.draggable_component.draggable_accepted.connect\
			.call_deferred(removed_item_holder)


func get_item_stack() -> Stack:
	if item_holder != null:
		return item_holder.stack
	return Stack.new()

func set_item_stack(stack:Stack) -> void:
	var new_item_holder: ItemHolder = ItemHolder.get_scene().instantiate()
	set_item_holder(new_item_holder)
	new_item_holder.stack = stack
