extends Control

@export var options_button: Button
@export var continue_button: Button
@export var new_game_button: Button
@export var quit_button: Button
@export var credits_button: Button
@export var close_credits_button: Button
@export var credits_screen: Control

@export var buttons_container: Container
@export var title_label: Label

@export var shop_path: String

func _ready() -> void:
	continue_button.grab_focus()
	OptionsMenu.options_menu_closed.connect(continue_button.grab_focus)
	continue_button.pressed.connect(continue_pressed)
	options_button.pressed.connect(open_options)
	new_game_button.pressed.connect(new_game_pressed)
	quit_button.pressed.connect(quit)
	credits_button.pressed.connect(credits_screen.show)
	close_credits_button.pressed.connect(credits_screen.hide)

func quit() -> void:
	get_tree().quit()

func open_options() -> void:
	OptionsMenu.open_options_menu()

func continue_pressed() -> void:
	SaveManager.load_game()

	if SaveManager.saved_scene_path.is_empty():
		start()
		return

	SaveManager.continue_saved_game()
	
func new_game_pressed() -> void:
	TutorialDirector.tutorial_day = true
	TutorialDirector.portal_open = false
	TutorialDirector.customer_manager_queue.clear()

	TimeCycle.days_passed = 0
	TimeCycle.day_progress = 0.0
	TimeCycle.target_day_progress = 0.0
	TimeCycle.visited_forest_this_day = false

	CustomerManager.customer_queue.clear()
	CustomerManager.returning_from_forest = false
	Portal.spawn_at_portal = false
	DayStarter.fired = false

	SaveManager.restoring_session = false
	PersistentInventory.hotbar_data.clear()
	PersistentInventory.money = 200
	
	Notebook.open_on_tutorial_page = true
	DayStarter.show_initial_tutorial = true

	start()

func start() -> void:
	SceneManager.change_active_scene_to_file(shop_path,SceneManager.TRANSITIONS.FADE)
