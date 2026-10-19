## add as child of a ui element that you want to be draggable
class_name ClickableComponent extends Node
#this code and the coupled DraggableAcceptor make liberal use of get_parent()
#which is generally bad when overused but there is no other oppurtunity

#if you encounter bugs to do with positioning while dragging, consider
#changing this code to use offset_transform

static var dragged_control: Control
static var the_cunt: ClickableComponent
static var pending_acceptor: ClickableAcceptorComponent

static func end_me(_dragged, cunt):
	dragged_control = _dragged
	the_cunt = cunt

@export var trash_collector: Control

var being_dragged: bool = false
var my_control: Control

#use these in the control that uses this component if you want
#functionality when dragging or dropping
signal request_pickup

func _ready() -> void:
	assert(get_parent() is Control, "draggable component not child of control")
	my_control = get_parent()
	
	set_process(false)


# Only runs if being dragged
func _process(_delta: float) -> void:
	if dragged_control == my_control:
		move_to_mouse()
		
		# Following Inputs will try to place component
		if Input.is_action_just_pressed("LMB"):
			# If no new pending parent to
			if not pending_acceptor:
				# erased idk
				pass
			else:
				request_pending_parent_placement()
				pending_acceptor.emit_request_left_placement(self)
				pass
			pass
		elif Input.is_action_just_pressed("RMB"):
			#list to acceptor but for RMB
			if pending_acceptor:
				request_pending_parent_placement()
				pending_acceptor.emit_request_right_placement(self)
			pass


func _unhandled_input(event: InputEvent) -> void:
	if not being_dragged:
		# Start dragging if cursor hovering & nothing else is being dragged
		if event.is_action_pressed("LMB") and\
			my_control.get_global_rect().has_point(\
			my_control.get_global_mouse_position()) and \
			dragged_control == null:
			
			request_pickup.emit()


func assign_to_mouse() -> void:
	my_control.top_level = true
	being_dragged = true
	end_me(my_control, self)
	
	my_control.reparent(trash_collector)
	
	move_to_mouse()
	
	set_process(true)


func move_to_mouse() -> void:
	my_control.global_position = my_control.get_global_mouse_position() - my_control.get_global_rect().size/2

# Called when dragged to ensure returns to orignal owner
func request_pending_parent_placement() -> void:
	# Actually Nothing
	pass


func place_clickable(new_parent : Control) -> void:
	my_control.reparent(new_parent)
	stop_dragging()

func die():
	stop_dragging()
	queue_free()

func stop_dragging() -> void:
	pending_acceptor = null
	dragged_control = null
	the_cunt = null
	
	being_dragged = false
	set_process(false)
	my_control.top_level = false
	
	#I hate everything
	my_control.global_position = my_control.get_parent().global_position


func get_acceptor(node: Node) -> DraggableAcceptorComponent:
	for child in node.get_children():
		if child is DraggableAcceptorComponent:
			return child
	
	return null
