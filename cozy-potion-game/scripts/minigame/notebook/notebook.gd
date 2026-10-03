class_name Notebook
extends Minigame

@onready var item_display_page: NotebookItemDisplay = $ItemDisplayPage
@onready var exit_button: TextureButton = $ExitButton

func _ready() -> void:
	item_display_page.reset_display()
	exit_button.pressed.connect(close_notebook)


func set_display(ingre : PotionIngredient) -> void:
	item_display_page.reset_display()
	item_display_page.set_potion_ingredient(ingre)


func close_notebook() -> void:
	minigame_won.emit()
