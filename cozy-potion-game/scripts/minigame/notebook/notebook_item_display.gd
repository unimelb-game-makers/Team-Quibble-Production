class_name NotebookItemDisplay
extends Node

@onready var sprite: TextureRect = $ItemDisplayPage/Sprite
@onready var label_name: Label = $ItemDisplayPage/Name
@onready var label_descrip: Label = $ItemDisplayPage/Description
@onready var label_att_title: Label = $ItemDisplayPage/AttributeTitle
@onready var label_att_list: Label = $ItemDisplayPage/AttributeList

@onready var pedia: Control = $Pedia
@onready var item_array: NotebookItemArray = $Pedia/ItemArray
@onready var left_arrow: TextureButton = $Pedia/LeftArrow
@onready var right_arrow: TextureButton = $Pedia/RightArrow


func _ready() -> void:
	pedia.visible = true
	item_array.item_clicked.connect(holder_clicked)
	
	left_arrow.pressed.connect(move_item_pages.bind(-1))
	right_arrow.pressed.connect(move_item_pages.bind(1))
	
	empty_display()

func empty_display() -> void:
	sprite.texture = null
	label_name.text = ""
	label_descrip.text = ""
	label_att_title.text = ""
	label_att_list.text = ""

func reset_display() -> void:
	sprite.texture = null
	label_name.text = ""
	label_descrip.text = ""
	label_att_title.text = "Attributes"
	label_att_list.text = ""


func set_item_grid_visbile(visible: bool) -> void:
	pedia.visible = visible


func holder_clicked(holder : ItemHolder) -> void:
	set_potion_ingredient(holder.get_item_stack().item)


func move_item_pages(amount : int) -> void:
	item_array.change_item_page(item_array.current_page + amount)


func set_potion_ingredient(ingre :PotionIngredient) -> void:
	reset_display()
	
	sprite.texture = ingre.ingredient_sprite
	label_name.text = ingre.ingredient_name
	label_descrip.text = "Nothing Here Yet"
	set_att_list(ingre)


func set_att_list(ingre :PotionIngredient) -> void:
	var keys : Array[Alchemy.AttributeID]= ingre.attributes.keys()
	keys.sort_custom(func(a:Alchemy.AttributeID, b:Alchemy.AttributeID):\
			return ingre.attributes[a] > ingre.attributes[b])
	
	for att in keys:
		if ingre.attributes[att] != 0:
			if label_att_list.text != "":
				label_att_list.text += "\n"
			label_att_list.text += Alchemy.AttributeID.keys()[att].substr(5) +\
				 ": " + str(ingre.attributes[att])
