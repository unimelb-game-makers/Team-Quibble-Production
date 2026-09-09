extends Control
class_name ListManager

@onready var vbox: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer

var customer_need_label: PackedScene = preload("res://scenes/user_interface/customer_need_label.tscn")

func _ready() -> void:
	Utils.list_manager = self

func create_list(customer: Customer):
	clear_list()
	for need in customer.needs:
		var label: Label = customer_need_label.instantiate()
		vbox.add_child(label)
		label.text = "- " + Utils.canonise_string(need)

func clear_list():
	if vbox.get_child_count() > 0:
		for child in vbox.get_children():
			child.queue_free()
