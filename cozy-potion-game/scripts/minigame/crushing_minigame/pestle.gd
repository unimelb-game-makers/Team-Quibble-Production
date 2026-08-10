class_name Pestle extends CharacterBody2D
## a character body that moves towards the mouse with some velocity

@export var max_speed: float
@export var curve: Curve

func _physics_process(_delta: float) -> void:
	#direction to move
	var mouse_world_position = get_viewport().get_mouse_position()
	var move_dir = (mouse_world_position - position).normalized()
	
	#the speed we move towards the cursor is dependent on how far away we are from it
	# in relation to how far away we could be from it
	var max_distance = sqrt(get_window().size.x*get_window().size.x + get_window().size.y * get_window().size.y)
	var distance = mouse_world_position.distance_to(position)
	
	#use this weight to sample a curve for the actual lerp weight
	var lerp_weight = curve.sample_baked(distance/max_distance)
	
	#move
	velocity = move_dir  * lerp(0.0, max_speed, lerp_weight)
	
	move_and_slide()
