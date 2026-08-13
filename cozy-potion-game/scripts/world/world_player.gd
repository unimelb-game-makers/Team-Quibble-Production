class_name WorldPlayer extends CharacterBody3D

## Player moves on the horizontal plane using a vector given by the movement keys
## the camera is centred on the player, and determines the direction of "up", etc
## the player can move the camerain 90 degree increments using a different set of
## movement keys.

@export var animation_pivot: Node3D
@onready var camera = get_viewport().get_camera_3d()
@export var camera_pivot: Node3D
@export var mouse_detector_left: Control
@export var mouse_detector_right: Control
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_ZOOM_MAGNITUDE = 0.1
const TURN_RATE = 2 * PI
const CAMERA_ROTATION_SPEED = 2 * PI
var camera_sensitivity = 1
var rotation_y_target: float = 0

func _ready() -> void:
	mouse_detector_left.mouse_entered.connect(rotate_camera.bind(-1))
	mouse_detector_right.mouse_entered.connect(rotate_camera.bind(1))

func _unhandled_input(event: InputEvent) -> void:
	character_movement(event)

func character_movement(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		rotate_camera(-1)
	elif event.is_action_pressed("ui_right"):
		rotate_camera(1)
	elif event.is_action_pressed("ui_up"):
		zoom_camera(-1)
	elif event.is_action_pressed("ui_down"):
		zoom_camera(1)

func rotate_camera(direction: int) -> void:
	#i really hope this implementation isnt what i stick with
	if not is_equal_approx(rotation_y_target, 0):
		return
	rotation_y_target = PI/2 * direction
	
	#rotate_y(PI/2 * direction)
	#animation_pivot.rotate_y(PI/2 * direction)

func zoom_camera(direction: int) -> void:
	if not camera.projection == Camera3D.ProjectionType.PROJECTION_ORTHOGONAL:
		return
	camera.size += CAMERA_ZOOM_MAGNITUDE * direction

func _process(delta: float) -> void:
	const epsilon = PI/24
	if not is_equal_approx(rotation_y_target, 0):
		var rot = delta * CAMERA_ROTATION_SPEED * sign(rotation_y_target)
		rotate_y(rot)
		var sign = sign(rotation_y_target)
		rotation_y_target -= rot
		#overshoot
		if sign != sign(rotation_y_target):
			rotate_y(rotation_y_target)
			rotation_y_target = 0
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# rotates the direction angle to account for the camera
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		 #rotates the animation pivot (that is, the actual mesh as well as the 
		 #detector for interactable objects)
		 #towards the movement direction at a rate of turn_rate per frame unless
		 #we could just snap to that direction.
		 #this implementation is a little overcomplicated so we can do smoothing
		 #if that isnt needed and you are not me, maybe just use look_at()
		var pivot_direction := animation_pivot.global_basis * Vector3.FORWARD
		var angle_to_move_dir = pivot_direction.signed_angle_to(direction, Vector3(0,1,0))
		var rotation = min(delta * TURN_RATE, abs(angle_to_move_dir)) * sign(angle_to_move_dir)
		animation_pivot.rotate_y(rotation)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
