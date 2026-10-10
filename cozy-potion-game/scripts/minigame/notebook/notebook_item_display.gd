class_name NotebookItemDisplay
extends Node


@onready var sprite: TextureRect = $Sprite
@onready var label_name: Label = $Name
@onready var label_descrip: Label = $Description
@onready var label_att_title: Label = $AttributeTitle
@onready var label_att_list: Label = $AttributeList


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
