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
@export var polygon: Polygon2D
@export var collision_polygon: CollisionPolygon2D
@export var collision_area: Area2D
@export var sprite_2d: Sprite2D

# WHY are these all exports :(

## TODO: placeholder
@export var crushed_sprite: Texture2D

var internal_scale = 1

var color: Color = Color.BLACK

#signal split_into(_ingredient: IngredientBall)

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
			
			new_ball.set_texture_and_color(crushed_sprite, color)
			get_parent().call_deferred("add_child", new_ball)
		
		queue_free()


#update the internal scale of the rigidbody and scale all of its children
#to match. the markers are also moved inward
#oh my god this is so bad
func set_internal_scale(new_scale: float) -> void:
	internal_scale = new_scale
	#polygon.scale = Vector2.ONE * internal_scale
	#collision_polygon.scale = Vector2.ONE * internal_scale
	$CollisionShape2D.scale = Vector2.ONE * internal_scale
	collision_area.scale = Vector2.ONE * internal_scale
	sprite_2d.scale = Vector2.ONE * 2 * internal_scale
	
	for marker in split_markers:
		marker.position *= new_scale


# colliding directly with the rigidbody proved unreliable so we collide with an area
# around it instead
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Pestle:
		#print_debug(body.velocity.length())
		if body.velocity.length() > min_split_vel:
			split()

func set_texture_and_color(_texture: Texture2D, _color: Color, _apply_color: bool = true) -> void:
	print(_color)
	sprite_2d.set_texture(_texture)
	color = _color
	if _apply_color:
		modulate = _color
