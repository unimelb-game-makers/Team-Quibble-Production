class_name CrushingMinigame extends Minigame
#controller for mortar and pestle scene

@export var ball_spawn_marker: Marker2D

@export var win_check_interval: float = 0.1
@export var ingredient_ball_scene: PackedScene
var win_check_timer: float

func _ready() -> void:
	ingredient_added.connect(_on_ingredient_added)
	spawn_ball()

func _on_ingredient_added(ingredient: Stack):
	spawn_ball()

func spawn_ball():
	var ball: IngredientBall = ingredient_ball_scene.instantiate()
	add_child(ball)
	ball.position = ball_spawn_marker.position
	
#checks all the objects with tag ingredient ball to see if any have not reached their split limit
#runs every 0.1 seconds or so
func check_if_won() -> void:
	var do_balls_exist: bool = false
	for object in get_tree().get_nodes_in_group(Utils.Group.GROUP_INGREDIENT_BALL):
		if object is IngredientBall:
			do_balls_exist = true
			if object.split_count < object.split_limit:
				return
	
	print_debug(do_balls_exist)
	if do_balls_exist:
		win_minigame()


func _process(delta: float) -> void:
	win_check_timer += delta
	
	if win_check_timer > win_check_interval:
		check_if_won()
		win_check_timer = 0

func _apply_ingredient(_new_ingredient: Stack) -> void:
	if hotbar.item_slots[input_index].stack.isEmpty:
		win_minigame()
	
	for object in get_tree().get_nodes_in_group("IngredientBall"):
		object.set_texture_and_color(_new_ingredient.get_sprite(), Color.RED, false)
