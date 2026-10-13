class_name Notebook
extends Minigame

const NOTEBOOK_TUTORIAL = preload("uid://bio4negeixv1a")
const NOTEBOOK_PEDIA_VIEW = preload("uid://deay4dct1lmci")
const NOTEBOOK = preload("uid://bgulnwmxdnlnl")

var loaded_page : CanvasLayer

@onready var display: Control = $Display
@onready var tutorial_page_button: TextureButton = $TutorialPageButton
@onready var pedia_page_button: TextureButton = $PediaPageButton
@onready var exit_button: TextureButton = $ExitButton
@onready var page_turn_animation: AnimatedSprite2D = $CenterContainer/BehindBackpage/PageTurnAnimation

# Uses the popup subwindow to open notebook
static func open_notebook(popup_subwindow : PopupSubWindow) -> void:
	popup_subwindow.start_display_popup(NOTEBOOK)


func _ready() -> void:
	load_page_without_animation(NOTEBOOK_PEDIA_VIEW)
	
	exit_button.pressed.connect(win_minigame)
	
	# Cheat but only like 3 buttons so what does it matter
	tutorial_page_button.pressed.connect(load_page.bind(NOTEBOOK_TUTORIAL))
	pedia_page_button.pressed.connect(load_page.bind(NOTEBOOK_PEDIA_VIEW))


func load_page_without_animation(new_page : PackedScene) -> void:
	if loaded_page != null:
		loaded_page.queue_free()
	
	if loaded_page == new_page:
		return
	
	loaded_page = new_page.instantiate()
	display.add_child(loaded_page)


func load_page(new_page : PackedScene) -> void:
	if loaded_page == new_page:
		return
	
	load_page_without_animation(new_page)
	
	loaded_page.visible = false
	page_turn_animation.play("default")
	await page_turn_animation.animation_finished
	loaded_page.visible = true


func close_notebook() -> void:
	minigame_won.emit()
