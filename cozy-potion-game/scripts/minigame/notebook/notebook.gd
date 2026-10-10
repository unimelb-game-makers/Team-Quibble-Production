class_name Notebook
extends Minigame

const NOTEBOOK_TUTORIAL = preload("uid://bio4negeixv1a")
const NOTEBOOK_PEDIA_VIEW = preload("uid://deay4dct1lmci")

@onready var display: Control = $Display
@onready var tutorial_page_button: TextureButton = $TutorialPageButton
@onready var pedia_page_button: TextureButton = $PediaPageButton
@onready var exit_button: TextureButton = $ExitButton

var loaded_page : CanvasLayer

func _ready() -> void:
	load_page(NOTEBOOK_PEDIA_VIEW)
	
	exit_button.pressed.connect(win_minigame)
	
	# Cheat but only like 3 buttons so what does it matter
	tutorial_page_button.pressed.connect(load_page.bind(NOTEBOOK_TUTORIAL))
	pedia_page_button.pressed.connect(load_page.bind(NOTEBOOK_PEDIA_VIEW))


func load_page(new_page : PackedScene) -> void:
	if loaded_page != null:
		loaded_page.queue_free()
	
	loaded_page = new_page.instantiate()
	display.add_child(loaded_page)


func close_notebook() -> void:
	minigame_won.emit()
