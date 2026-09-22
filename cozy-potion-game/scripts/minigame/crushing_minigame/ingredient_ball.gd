class_name IngredientBall extends RigidBody2D
## A gravity-affected rigidbody.
## if it collides with an object with the mortar class at a certain
## velocity, it splits in two, up to a limit

#max splits
@export var split_limit: int
#the split count that this instance is on
@export var split_count: int
#minimum velocity to split
@export var min_split_vel: float
# the positions to place the split balls
@export var split_markers: Array[Marker2D]
#scale of new balls
@export var split_scale: float
#godot doesn't allow scaling rigidbodies, so we have to do a bit of a workaround
@export var collision_shape: CollisionShape2D
@export var collision_area: Area2D
@export var ingredient_sprite: Sprite2D
@export var ingredient_background: Sprite2D

# WHY are these all exports :(
# best practice ;(

var internal_scale = 1

#period of time that ticks down in process in which ingredients cannot be
#crushed further
@export var base_grace_period: float = 0.2
var grace_period: float = 0.2


func _ready() -> void:
	grace_period = base_grace_period

#if this ball can still split, for each marker in the split markers array,
#generate a smaller duplicate of this ball and increment its split count, then put it on that marker
func split() -> void:
	if split_count < split_limit:
		for marker in split_markers:
			var new_ball: IngredientBall = duplicate()
			#split_into.emit(new_ball)
			new_ball.split_count += 1
			new_ball.global_position = marker.global_position
			new_ball.set_internal_scale(internal_scale * split_scale)
		
			get_parent().call_deferred("add_child", new_ball)
		
		queue_free()


#update the internal scale of the rigidbody and scale all of its children
#to match. the markers are also moved inward
#oh my god this is so bad
func set_internal_scale(new_scale: float) -> void:
	internal_scale = new_scale
	collision_shape.scale = Vector2.ONE * internal_scale
	collision_area.scale = Vector2.ONE * internal_scale
	ingredient_background.scale = Vector2.ONE * internal_scale
	ingredient_sprite.scale = Vector2.ONE * 0.8 * internal_scale
	
	for marker in split_markers:
		marker.position *= new_scale

func _process(delta: float) -> void:
	grace_period -= delta

# colliding directly with the rigidbody proved unreliable so we collide with an area
# around it instead
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Pestle:
		#print_debug(body.velocity.length())
		if body.velocity.length() > min_split_vel:
			split()

func set_texture_and_color(_texture: Texture2D, _color: Color, _apply_color: bool = true) -> void:
	ingredient_sprite.set_texture(_texture)
	if _apply_color:
		ingredient_sprite.modulate = _color
