class_name NotebookItemDisplay
extends Node


@onready var sprite: TextureRect = $MarginContainer3/VBoxContainer/Sprite
@onready var label_name: Label = $MarginContainer3/VBoxContainer/Name
@onready var label_descrip: Label = $MarginContainer3/VBoxContainer/MarginContainer/Description
@onready var label_att_title: Label = $MarginContainer3/VBoxContainer/AttributeTitle
@onready var label_att_list: Label = $MarginContainer3/VBoxContainer/MarginContainer2/AttributeList

@onready var background_container: CenterContainer = $CenterContainer


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


func show_background() -> void:
	background_container.visible = true


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
	
	var text : String = ""
	for att in keys:
		if ingre.attributes[att] != 0:
			if text != "":
				text += "\n"
			text += Alchemy.AttributeID.keys()[att].substr(5) +\
				 ": " + str(ingre.attributes[att])
	
	label_att_list.text = text
