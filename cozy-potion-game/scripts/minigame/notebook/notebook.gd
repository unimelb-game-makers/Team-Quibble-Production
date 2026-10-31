class_name Notebook
extends Minigame

const NOTEBOOK_TUTORIAL = preload("uid://bio4negeixv1a")
const NOTEBOOK_PEDIA_VIEW = preload("uid://deay4dct1lmci")
const NOTEBOOK_PROCESS_VIEW = preload("uid://b8oobmqd0kur3")

const NOTEBOOK = preload("uid://bgulnwmxdnlnl")

var loaded_page : Control

@onready var display: Control = $ThePage/PageCenter/Display

@onready var tutorial_page_button: TextureButton = $ThePage/PageBar/TutCentreContainer/TutorialPageButton
@onready var pedia_page_button: TextureButton = $ThePage/PageBar/ItemPedia/PediaPageButton
@onready var process_view_button: TextureButton = $ThePage/PageBar/ProcessView/ProcessViewButton

@onready var exit_button: TextureButton = $ThePage/PageBar/Exit/ExitButton

@onready var page_turn_animation: AnimatedSprite2D = $ThePage/PageCenter/BehindBackpage/PageTurnAnimation

# Uses the popup subwindow to open notebook
static func open_notebook(popup_subwindow : PopupSubWindow) -> void:
	popup_subwindow.start_display_popup(NOTEBOOK)


func _ready() -> void:
	page_turn_animation.visible = false
	load_page_without_animation(NOTEBOOK_PEDIA_VIEW)
	
	exit_button.pressed.connect(win_minigame)
	
	# Cheat but only like 3 buttons so what does it matter
	tutorial_page_button.pressed.connect(load_page.bind(NOTEBOOK_TUTORIAL))
	pedia_page_button.pressed.connect(load_page.bind(NOTEBOOK_PEDIA_VIEW))
	process_view_button.pressed.connect(load_page.bind(NOTEBOOK_PROCESS_VIEW))


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
	page_turn_animation.visible = true
	page_turn_animation.play("default")
	await page_turn_animation.animation_finished
	page_turn_animation.visible = false
	loaded_page.visible = true


func close_notebook() -> void:
	minigame_won.emit()
