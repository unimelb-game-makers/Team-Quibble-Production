class_name DragBox
extends Area2D

# Exists in conjuction with place_box

# Home Container that stores draggable, (could be removed for extension)
@export var home: Container 

# is the parent being dragged
var dragging := false
# Parent to be dragged
@onready var parent := get_parent() 

# Signal activates when dragBox dropped
signal dropped


func _ready() -> void:
	input_event.connect(start_dragging)
	set_process(false)

# Activated when dragging begins, puts parent on mouse while dragging
# stops dragging when LMB released
func _process(delta: float) -> void:
	if dragging:
		if Input.is_action_just_released("LMB"):
			dragging = false
			parent.top_level = false
			
			dropped.emit()
			set_process(false)
		else:
			parent.global_position = get_global_mouse_position()

# Returns home container
func get_home() -> Container:
	return home


# Begins dragging, called when LMB pressed on dragbox
func start_dragging(_viewport: Node,event: InputEvent, _shape_idx: int) -> void:
	if !dragging and event.is_action_pressed("LMB"):
		dragging = true
		parent.top_level = true
		set_process(true)
		
		# If previously on step, places under storage again
		parent.reparent(home)

# Called to reparent parent to placeBox container
func place_in(area: Area2D) -> void:
	if dragging and area is PlaceBox:
		area.placed_dragbox(self)
		
		parent.reparent.call_deferred(area.get_home())
		parent.position = Vector2.ZERO
