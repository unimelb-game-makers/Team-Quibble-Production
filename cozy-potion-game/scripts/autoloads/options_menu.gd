extends Node

var options_menu_container: Container:
	get():
		if options_menu_container:
			return options_menu_container
		elif is_inside_tree():
			options_menu_container = get_tree().get_first_node_in_group("OptionsMenuContainer")
			return options_menu_container
		return null

func _ready() -> void:
	options_menu_container = get_tree().get_first_node_in_group("OptionsMenuContainer")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_left"):
		open_options_menu()
	if event.is_action("camera_right"):
		close_options_menu()

func open_options_menu() -> void:
	#TODO give focus to first button in the options menu for non-mouse users
	animate_options_menu_in()

func close_options_menu() -> void:
	animate_options_menu_out()

func animate_options_menu_in() -> void:
	if not options_menu_container:
		return
		
	var tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(options_menu_container, "offset_transform_position", Vector2.ZERO, 0.2)

func animate_options_menu_out() -> void:
	if not options_menu_container:
		return
		
	var tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	var out_pos = get_options_menu_out_position()
	print_debug(out_pos)
	tween.tween_property(options_menu_container, "offset_transform_position", out_pos, 0.2)

func get_options_menu_out_position() -> Vector2:
	return Vector2(-(options_menu_container.global_position.x + options_menu_container.size.x), 0)
