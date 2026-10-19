extends Control
class_name CornerNeedsListManager

@export var vbox: VBoxContainer

var customer_need_label: PackedScene = preload("uid://dr6jiml0w14pj")

func _ready() -> void:
	Utils.corner_needs_list_manager = self

func create_list(customer: Customer):
	clear_list()
	for need in customer.needs:
		var label: Label = customer_need_label.instantiate()
		vbox.add_child(label)
		label.text = "- " + Utils.canonise_string(Utils.need_id_to_string(need))

func clear_list():
	if vbox.get_child_count() > 0:
		for child in vbox.get_children():
			child.queue_free()
