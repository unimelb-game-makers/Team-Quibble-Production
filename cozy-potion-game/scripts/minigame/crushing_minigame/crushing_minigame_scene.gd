extends Minigame
#controller for mortar and pestle scene

@export var placeholder_stack: Stack

@export var win_check_interval: float = 0.1
var win_check_timer: float

func _ready() -> void:
	apply_ingredient(placeholder_stack)

#checks all the objects with tag ingredient ball to see if any have not reached their split limit
#runs every 0.1 seconds or so
func check_if_won() -> void:
	for object in get_tree().get_nodes_in_group("IngredientBall"):
		if object is IngredientBall:
			if object.split_count < object.split_limit:
				return
	
	win_minigame()


func _process(delta: float) -> void:
	win_check_timer += delta
	
	if win_check_timer > win_check_interval:
		check_if_won()
		win_check_timer = 0

func apply_ingredient(_new_ingredient: Stack) -> void:
	for object in get_tree().get_nodes_in_group("IngredientBall"):
		object.set_texture_and_color(placeholder_stack.get_sprite(), Color.RED, false)
