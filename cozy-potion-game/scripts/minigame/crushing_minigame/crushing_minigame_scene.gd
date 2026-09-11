class_name CrushingMinigame extends Minigame
#controller for mortar and pestle scene

@export var ball_spawn_marker: Marker2D

@export var win_check_interval: float = 0.1
@export var ingredient_ball_scene: PackedScene
var win_check_timer: float

func _ready() -> void:
	acceptor.accepted_draggable.connect(emit_ingredient_added)
	ingredient_added.connect(_on_ingredient_added)

func _on_ingredient_added(ingredient_stack: Stack):
	spawn_ball(ingredient_stack)
	
	output_ingredient = process_ingredient(ingredient_stack)


func process_ingredient(input_stack: Stack) -> Stack:
	print_debug("IT IS NOW TIME TO IMPLEMENT ITEM PROCESSING ON THIS LINE")
	input_stack.item.ingredient_name = "PROCESSED INGREDIENT"
	return input_stack


func spawn_ball(ingredient: Stack):
	var ball: IngredientBall = ingredient_ball_scene.instantiate()
	add_child(ball)
	ball.position = ball_spawn_marker.position
	ball.set_texture_and_color(ingredient.get_item_sprite(), Color.RED)
	
#checks all the objects with tag ingredient ball to see if any have not reached their split limit
#runs every 0.1 seconds or so
func check_if_won() -> void:
	var do_balls_exist: bool = false
	for object in get_tree().get_nodes_in_group(Utils.Group.GROUP_INGREDIENT_BALL):
		if object is IngredientBall:
			do_balls_exist = true
			if object.split_count < object.split_limit:
				return
	
	if do_balls_exist:
		win_minigame()


func _process(delta: float) -> void:
	win_check_timer += delta
	
	if win_check_timer > win_check_interval:
		check_if_won()
		win_check_timer = 0
