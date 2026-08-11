class_name WorldPlayer extends CharacterBody3D

## Player moves on the horizontal plane using a vector given by the movement keys
## the camera is centred on the player, and determines the direction of "up", etc
## the player can move the camerain 90 degree increments using a different set of
## movement keys.

@export var animation_pivot: Node3D
@onready var camera = get_viewport().get_camera_3d()
@export var camera_pivot: Node3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_ZOOM_MAGNITUDE = 0.1
var camera_sensitivity = 1

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
	rotate_y(PI/2 * direction)
	animation_pivot.rotate_y(PI/2 * direction)

func zoom_camera(direction: int) -> void:
	if not camera.projection == Camera3D.ProjectionType.PROJECTION_ORTHOGONAL:
		return
	camera.size += CAMERA_ZOOM_MAGNITUDE * direction


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
		animation_pivot.look_at(position + direction)
		print_debug(animation_pivot.basis)
		print_debug(direction)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
