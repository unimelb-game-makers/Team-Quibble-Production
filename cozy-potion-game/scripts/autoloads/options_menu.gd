extends CanvasLayer

@export_group("Menus")
@export var options_menu_container: Container
@export var sound_menu: Control

@export_group("Buttons")
@export var exit_game_button: Button
@export var sound_menu_button: Button

@export_group("Blur")
@export var blur_rect: ColorRect
@export_range(0.0, 5.0, 0.1) var blur_amount: float = 1.5

var blur_shader: ShaderMaterial
var open: bool = false
var animation_running: bool = false

var current_menu: Control
var menus: Array[Control]

func _ready() -> void:
	options_menu_container = get_tree().get_first_node_in_group("OptionsMenuContainer")
	if not options_menu_container.is_node_ready():
		await options_menu_container.ready
	options_menu_container.offset_transform_enabled = true
	
	blur_rect.material = load("uid://47ub0xvf0cjt")
	blur_shader = blur_rect.material
	blur_shader.set_shader_parameter("blur_amount", 0)
	blur_rect.hide()

	#wait for container resize
	await get_tree().process_frame
	options_menu_container.offset_transform_position = get_options_menu_out_position()
	# Handle Menus
	menus.append(options_menu_container)
	menus.append(sound_menu)
	for menu in menus:
		menu.hide()
	
	connect_buttons()

func connect_buttons() -> void:
	#TODO: exiting the game should probably be more graceful than this
	exit_game_button.pressed.connect(get_tree().quit)
	sound_menu_button.pressed.connect(open_sound_menu)

func _input(event: InputEvent) -> void:
	#print_debug(event.as_text())
	#print_debug(event.is_action_pressed("open_options_menu"))
	if event.is_action_pressed("open_options_menu"):
		if animation_running:
			return
		if not open:
			current_menu = options_menu_container
			open_options_menu()
		elif open and current_menu == options_menu_container:
			close_options_menu()
		elif open:
			blur_rect.hide()
			current_menu.hide()
			current_menu = options_menu_container
			open = false
			
			var focus_owner = get_viewport().gui_get_focus_owner()
			if focus_owner:
				focus_owner.release_focus()
		# this key should always open the options menu, and only
		# open the options menu
		get_viewport().set_input_as_handled()

# This will need continued refactoring such that each menu has its own script to call show and hide logic.
func open_menu(menu) -> void:
	menu.show()
	for _menu in menus:
		if _menu != menu:
			menu.hide()

# Return to main menu. Close all other menus.
# Each return button must connect to this function
func return_button_pressed() -> void:
	open_menu(options_menu_container)
	
	current_menu = options_menu_container
	animate_options_menu_in()

func open_sound_menu() -> void:
	open_menu(sound_menu)
	
	current_menu = sound_menu
	animate_options_menu_out()

func open_options_menu() -> void:
	#TODO give focus to first button in the options menu for non-mouse users
	if not options_menu_container:
		return
	open = true
	animate_blur()
	animate_options_menu_in()

func close_options_menu() -> void:
	if not options_menu_container:
		return
	
	open = false
	animate_unblur()
	animate_options_menu_out()
	
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner:
		focus_owner.release_focus()

func animate_options_menu_in() -> void:
	if not options_menu_container:
		return
	#calls show at start and end of animation in case of user spamming
	#the menu button
	animation_running = true
	options_menu_container.show()
	
	var tween = get_tree().create_tween()
	
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(options_menu_container, "offset_transform_position", Vector2.ZERO, 0.2)
	tween.tween_callback(options_menu_container.show)
	tween.tween_callback(func():animation_running = false)

func animate_options_menu_out() -> void:
	if not options_menu_container:
		return
	animation_running = true
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	var out_pos = get_options_menu_out_position()
	tween.tween_property(options_menu_container, "offset_transform_position", out_pos, 0.2)
	
	tween.tween_callback(options_menu_container.hide)
	tween.tween_callback(func():animation_running = false)

func animate_blur() -> void:
	blur_rect.show()
	var tween = get_tree().create_tween()
	tween.tween_property(blur_shader, "shader_parameter/blur_amount", blur_amount, 0.1)

func animate_unblur() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(blur_shader, "shader_parameter/blur_amount", 0, 0.1)
	tween.tween_callback(blur_rect.hide)

func get_options_menu_out_position() -> Vector2:
	return Vector2(-(options_menu_container.global_position.x + options_menu_container.size.x), 0)
