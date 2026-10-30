extends CanvasLayer

signal forced_customer_leave

@export var customer_leave_button: Button

@export var scene_switcher_button: MenuButton
@export var destination_strings: Array[String]
@export var fill_pantry_button: Button

func _ready() -> void:
	visible = false
	customer_leave_button.pressed.connect(customer_leave)
	setup_scene_switcher_menu_button()
	fill_pantry_button.pressed.connect(fill_pantry)

func setup_scene_switcher_menu_button() -> void:
	for string in destination_strings:
		scene_switcher_button.get_popup().add_item(string)
		scene_switcher_button.get_popup().id_pressed.connect(switch_scene)

func switch_scene(id: int) -> void:
	SceneManager.change_active_scene_to_file(destination_strings[id])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_console"):
		visible = !visible

func customer_leave():
	forced_customer_leave.emit()

func fill_pantry():
	for ingredient in Alchemy.ingredient_list:
		PersistentInventory.pantry.append(Stack.new(5,ingredient))
