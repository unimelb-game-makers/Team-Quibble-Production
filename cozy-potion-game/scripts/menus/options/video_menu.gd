extends MarginContainer

@export var resolution_option_button: OptionButton
@export var fps_option_button: OptionButton
@export var full_screen_button: CheckBox

@export var resolution_options: Array[Vector2i]
@export var fps_options: Array[int]


func _ready() -> void:
	resolution_option_button.item_selected.connect(_on_resolution_option_button_item_selected)
	fps_option_button.item_selected.connect(_on_fps_option_button_item_selected)
	full_screen_button.toggled.connect(_on_full_screen_button_toggled)

	var screen_size = DisplayServer.screen_get_size()
	if not resolution_options.has(screen_size):
		resolution_options.append(screen_size)

	for resolution in resolution_options:
		resolution_option_button.add_item("%dx%d" % [resolution.x, resolution.y])

	for fps in fps_options:
		fps_option_button.add_item("Unlimited" if fps == 0 else str(fps))

	full_screen_button.set_pressed_no_signal(
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	)

	resolution_option_button.select(resolution_options.find(
		screen_size if full_screen_button.button_pressed else get_window().size
	))
	fps_option_button.select(fps_options.find(Engine.max_fps))


func _on_resolution_option_button_item_selected(index: int) -> void:
	var resolution = resolution_options[index]

	if full_screen_button.button_pressed:
		var viewport = get_tree().get_first_node_in_group("GameSubViewport")
		viewport.scaling_3d_mode = Viewport.SCALING_3D_MODE_NEAREST
		viewport.scaling_3d_scale = minf(
			float(resolution.x) / viewport.size.x,
			float(resolution.y) / viewport.size.y
		)
	else:
		get_window().size = resolution
		get_window().move_to_center()


func _on_fps_option_button_item_selected(index: int) -> void:
	Engine.max_fps = fps_options[index]


func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on
		else DisplayServer.WINDOW_MODE_WINDOWED
	)
	_on_resolution_option_button_item_selected(resolution_option_button.selected)
