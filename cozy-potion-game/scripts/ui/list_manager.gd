extends Control
class_name ListManager

@onready var vbox: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer

var customer_need_label: PackedScene = preload("res://scenes/user_interface/customer_need_label.tscn")

var needs_dict: Dictionary = {"NEED_HEAL":"Heal Injury", "NEED_MANA":"Mana", "NEED_CURE": "Disease", 
	"NEED_FOCUS":"Focus", "NEED_STRENGTH":"Strength", "NEED_PERCEPTION":"Perception", "NEED_ENDURANCE":"Endurance"
	,"NEED_CHARISMA":"Charisma", "NEED_INTELLIGENCE":"Intelligence", "NEED_AGILITY":"Agility", "NEED_LUCK":"Luck",
	"NEED_FLAME":"Flame", "NEED_FROST":"Frost", "NEED_SHOCK":"Shock", "NEED_WIND":"Wind", "NEED_EARTH":"Earth",
	"NEED_WATER":"Water", "NEED_PURIFICATION":"Purification", "NEED_ANTIDOTE":"Poison", "NEED_SLEEP":"Sleep", "NEED_CALM":"Stress",
	"NEED_LIGHT":"Light", "NEED_DARK":"Dark", "NEED_PAIN_RELIEF":"Pain Relief"}

func _ready() -> void:
	Utils.list_manager = self

func create_list(customer: Customer):
	clear_list()
	for need in customer.needs:
		var label: Label = customer_need_label.instantiate()
		vbox.add_child(label)
		label.text = "- " + needs_dict[need]
func clear_list():
	if vbox.get_child_count() > 0:
		for child in vbox.get_children():
			child.queue_free()
