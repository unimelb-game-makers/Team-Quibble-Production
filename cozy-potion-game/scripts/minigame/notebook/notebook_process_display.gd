class_name NotebookProcessDisplay
extends Node


@onready var sprite: TextureRect = $MarginContainer3/VBoxContainer/Sprite
@onready var label_name: Label = $MarginContainer3/VBoxContainer/Name
@onready var label_descrip: Label = $MarginContainer3/VBoxContainer/MarginContainer/Description
@onready var what_it_does_title: Label = $MarginContainer3/VBoxContainer/WhatItDoesTitle
@onready var what_it_does_descrip: Label = $MarginContainer3/VBoxContainer/MarginContainer2/WhatItDoes

@onready var background_container: CenterContainer = $CenterContainer


func empty_display() -> void:
	sprite.texture = null
	label_name.text = ""
	label_descrip.text = ""
	what_it_does_title.text = ""
	what_it_does_descrip.text = ""


func reset_display() -> void:
	sprite.texture = null
	label_name.text = ""
	label_descrip.text = ""
	what_it_does_title.text = "What It Does"
	what_it_does_descrip.text = ""


func show_background() -> void:
	background_container.visible = true


func set_process_display(pid : Alchemy.ProcessID) -> void:
	reset_display()
	
	var process := Alchemy.find_process_by_id(pid)
	
	sprite.texture = process.texture
	label_name.text = process.name
	label_descrip.text = process.description
	what_it_does_descrip.text = process.tooltip
