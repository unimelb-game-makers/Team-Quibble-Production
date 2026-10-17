class_name NotebookPediaDisplay
extends Node

@onready var item_display: NotebookItemDisplay = $NotebookItemDisplay


@onready var pedia: Control = $Pedia
@onready var item_array: NotebookItemArray = $Pedia/ItemArray
@onready var left_arrow: TextureButton = $Pedia/LeftArrow
@onready var right_arrow: TextureButton = $Pedia/RightArrow


func _ready() -> void:
	pedia.visible = true
	item_array.item_clicked.connect(holder_clicked)
	
	left_arrow.pressed.connect(move_item_pages.bind(-1))
	right_arrow.pressed.connect(move_item_pages.bind(1))
	
	item_display.empty_display()


func set_item_grid_visbile(visible: bool) -> void:
	pedia.visible = visible


func holder_clicked(holder : ItemHolder) -> void:
	item_display.set_potion_ingredient(holder.get_item_stack().item)


func move_item_pages(amount : int) -> void:
	item_array.change_item_page(item_array.current_page + amount)
