extends CanvasLayer

@export var options_menu_container: Container
@export var exit_game_button: Button
var open: bool = false

func _ready() -> void:
	options_menu_container = get_tree().get_first_node_in_group("OptionsMenuContainer")
	if not options_menu_container.is_node_ready():
		await options_menu_container.ready
	options_menu_container.offset_transform_enabled = true
	
	#wait for container resize
	await get_tree().process_frame
	options_menu_container.offset_transform_position = get_options_menu_out_position()
	options_menu_container.hide()
	
	connect_buttons()

func connect_buttons() -> void:
	#TODO: exiting the game should probably be more graceful than this
	exit_game_button.pressed.connect(get_tree().quit)

func _input(event: InputEvent) -> void:
	print_debug(event.as_text())
	print_debug(event.is_action_pressed("open_options_menu"))
	if event.is_action_pressed("open_options_menu"):
		if not open:
			open_options_menu()
		else:
			close_options_menu()
		# this key should always open the options menu, and only
		# open the options menu
		get_viewport().set_input_as_handled()

func open_options_menu() -> void:
	#TODO give focus to first button in the options menu for non-mouse users
	if not options_menu_container:
		return
	open = true
	animate_options_menu_in()

func close_options_menu() -> void:
	if not options_menu_container:
		return
	
	open = false
	animate_options_menu_out()
	
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner:
		focus_owner.release_focus()

func animate_options_menu_in() -> void:
	if not options_menu_container:
		return
	#calls show at start and end of animation in case of user spamming
	#the menu button
	options_menu_container.show()
	var tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(options_menu_container, "offset_transform_position", Vector2.ZERO, 0.2)
	tween.tween_callback(options_menu_container.show)
func animate_options_menu_out() -> void:
	if not options_menu_container:
		return
		
	var tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	var out_pos = get_options_menu_out_position()
	tween.tween_property(options_menu_container, "offset_transform_position", out_pos, 0.2)
	tween.tween_callback(options_menu_container.hide)

func get_options_menu_out_position() -> Vector2:
	return Vector2(-(options_menu_container.global_position.x + options_menu_container.size.x), 0)
