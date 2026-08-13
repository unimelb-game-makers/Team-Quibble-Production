class_name DragBox
extends Area2D

@export var home: Container 

var dragging := false
@onready var parent := get_parent() 

signal dropped

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(start_dragging)
	set_process(false)


func get_home() -> Container:
	return home


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		if Input.is_action_just_released("LMB"):
			dragging = false
			parent.top_level = false
			
			dropped.emit()
			set_process(false)
		else:
			parent.global_position = get_global_mouse_position()

# Called when Ingredients feel input, trys to start dragging given ingredient
func start_dragging(_viewport: Node, event: InputEvent, _shape_idx: int) \
			-> void:
	if !dragging and event.is_action_pressed("LMB"):
		dragging = true
		parent.top_level = true
		set_process(true)
		
		# If previously on step, places under storage again
		parent.reparent(home)

func place_in(area: Area2D) -> void:
	if dragging and area is PlaceBox:
		area.placed_dragbox(self)
		
		parent.reparent.call_deferred(area.get_home())
		parent.position = Vector2.ZERO
