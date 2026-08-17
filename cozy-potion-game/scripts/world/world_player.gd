class_name WorldPlayer extends CharacterBody3D

## Player moves on the horizontal plane using a vector given by the movement keys
## the camera is centred on the player, and determines the direction of "up", etc
## the player can move the camerain 90 degree increments using a different set of
## movement keys.
## to modify the player's model, put it as a child of AnimationPivot
## for future interactable objects, use collision with the child
## InteractableCollision to determine whether the player is facing it

@export var animation_pivot: Node3D
@onready var camera = get_viewport().get_camera_3d()
@export var camera_pivot: Node3D
@export var mouse_detector_left: Control
@export var mouse_detector_right: Control
@export var interactable_collision_area: Area3D
@export var mimi_sprite: Node3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const CAMERA_ZOOM_MAGNITUDE = 0.1
const INTERACTABLE_AREA_TURN_RATE = 10 * PI
const CAMERA_ROTATION_SPEED = 2 * PI

var rotation_y_target: float = 0
var top_down_active: bool = false

func _ready() -> void:
	mouse_detector_left.mouse_entered.connect(rotate_camera.bind(-1))
	mouse_detector_right.mouse_entered.connect(rotate_camera.bind(1))

func _unhandled_input(event: InputEvent) -> void:
	aesthetic_movement(event)

func aesthetic_movement(event: InputEvent) -> void:
	if event.is_action_pressed("camera_left"):
		rotate_camera(-1)
	if event.is_action_pressed("camera_right"):
		rotate_camera(1)
	if event.is_action("zoom_in") :
		zoom_camera(-1)
	if event.is_action("zoom_out"):
		zoom_camera(1)
		
	if event.is_action_pressed("move_left") and facing == -1:
		flip_mimi()
	if event.is_action_pressed("move_right") and facing == 1:
		flip_mimi()
	if event.is_action_pressed("move_up"):
		tilt_mimi(-1)
	if event.is_action_released("move_up"):
		tilt_mimi(1)
	if event.is_action_pressed("move_down"):
		tilt_mimi(1)
	if event.is_action_released("move_down"):
		tilt_mimi(-1)
	if event.is_action_pressed("interact"):
		interact()

func rotate_camera(direction: int) -> void:
	#i really hope this implementation isnt what i stick with
	if not is_equal_approx(rotation_y_target, 0):
		return
	rotation_y_target += PI/2 * direction
	

func zoom_camera(direction: int) -> void:
	if not camera.projection == Camera3D.ProjectionType.PROJECTION_ORTHOGONAL:
		return
	camera.size += CAMERA_ZOOM_MAGNITUDE * direction

func _process(delta: float) -> void:
	process_camera_rotation(delta)

##rotates the camera each frame according to the rotation target.
func process_camera_rotation(delta: float) -> void:
	if not is_equal_approx(rotation_y_target, 0):
		var rot = delta * CAMERA_ROTATION_SPEED * sign(rotation_y_target)
		# we rotate the camera by rotating the player, which makes it easier
		# for them to walk in the right direction.
		# however we dont want camera rotation to rotate the player's model
		# so we rotate the model the other way
		rotate_y(rot)
		animation_pivot.rotate_y(-rot)
		var sign = sign(rotation_y_target)
		rotation_y_target -= rot
		#overshoot
		if sign != sign(rotation_y_target):
			rotate_y(rotation_y_target)
			animation_pivot.rotate_y(-rotation_y_target)
			rotation_y_target = 0

	#if this gets used again i'll make it a function, or maybe a class.
	if not is_equal_approx(mimi_target_rotation, 0):
		var rot = delta * CAMERA_ROTATION_SPEED * sign(mimi_target_rotation)
		# we rotate the camera by rotating the player, which makes it easier
		# for them to walk in the right direction.
		# however we dont want camera rotation to rotate the player's model
		# so we rotate the model the other way
		mimi_sprite.rotate_y(rot)		
		var sign = sign(mimi_target_rotation)
		mimi_target_rotation -= rot
		#overshoot
		if sign != sign(mimi_target_rotation):
			mimi_sprite.rotate_y(mimi_target_rotation)
			mimi_target_rotation = 0

func get_input_vector_unnormalised() -> Vector2i:
	var res := Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		res.x += 1
	if Input.is_action_pressed("move_right"):
		res.x -= 1
	if Input.is_action_pressed("move_up"):
		res.y -= 1
	if Input.is_action_pressed("move_down"):
		res.y += 1
	return res

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
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
		 #if that isnt needed, maybe just use look_at()
		var pivot_direction := animation_pivot.global_basis * Vector3.FORWARD
		var angle_to_move_dir = pivot_direction.signed_angle_to(direction, Vector3(0,1,0))
		var rotation = min(delta * INTERACTABLE_AREA_TURN_RATE, abs(angle_to_move_dir)) * sign(angle_to_move_dir)
		animation_pivot.rotate_y(rotation)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func toggle_top_down_cam() -> void:
	if not top_down_active:
		activate_top_down_cam()
		top_down_active = true
	else:
		deactivate_top_down_cam()
		top_down_active = false

func deactivate_top_down_cam() -> void:
	rotation_y_target += PI/4
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(camera, "rotation_degrees", Vector3(-45,0,0), 0.2)
	var tween2 = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property(camera, "position", Vector3(0,7.0,7.0), 0.2)
	
func activate_top_down_cam() -> void:
	rotation_y_target -= PI/4
	#can use a tween here because we don't need to worry about angles wrapping
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(camera, "rotation_degrees", Vector3(-90,0,0), 0.2)
	var tween2 = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property(camera, "position", Vector3(0,7.0,0), 0.2)
	
func interact() -> void:
	for area in interactable_collision_area.get_overlapping_areas():
		if area is InteractableArea:
			area.interacted.emit()
			# probably bad to interact with two things at once
			return

var facing: int = 1
var tilting: int = 0
var tilting_angle = PI/4
var mimi_target_rotation: float = 0

#the following functions were revealed to me in a dream
func flip_mimi():
	mimi_target_rotation += (PI - tilting_angle * 2 * abs(tilting)) * facing * sign(tilting+0.5)
	facing *= -1

func tilt_mimi(direction: int):
	mimi_target_rotation += tilting_angle * direction * facing
	tilting += direction
