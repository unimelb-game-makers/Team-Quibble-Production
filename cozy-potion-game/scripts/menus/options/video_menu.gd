extends MarginContainer

@export var resolution_option_button: OptionButton
@export var fps_option_button: OptionButton
@export var full_screen_button: Button

@export var resolution_options: Array[Vector2i]
@export var fps_options: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resolution_option_button.item_selected.connect(_on_resolution_option_button_item_selected)
	fps_option_button.item_selected.connect(_on_fps_option_button_item_selected)
	full_screen_button.toggled.connect(_on_full_screen_button_toggled)

	for i in resolution_options.size():
		var resolution: Vector2i = resolution_options[i]
		resolution_option_button.add_item(str(resolution.x) + "x" + str(resolution.y), i)
	
	for i in fps_options.size():
		var fps_value: String = str(fps_options[i])
		if fps_options[i] == 0:
			fps_value = "Unlimited"
		fps_option_button.add_item(fps_value, i)

func _on_resolution_option_button_item_selected(index: int) -> void:
	get_tree().root.size = resolution_options[index]

func _on_fps_option_button_item_selected(index: int) -> void:
	Engine.set_max_fps(fps_options[index])

func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
