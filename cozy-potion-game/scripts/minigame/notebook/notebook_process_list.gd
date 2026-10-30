class_name ProcessList
extends Node

signal process_chosen(pid: Alchemy.ProcessID)

const PROCESS_LISTED : Array[Alchemy.ProcessID] = [Alchemy.ProcessID.PROC_GRIND]

var process_buttons : Array[Button] = []

@onready var template_button: Button = $TemplateButton


func _ready() -> void:
	add_processes_to_list()


func add_processes_to_list() -> void:
	for pid in PROCESS_LISTED:
		var new = template_button.duplicate()
		add_child(new)
		process_buttons.append(pid)
		new.visible = true
		new.text = Alchemy.find_process_by_id(pid).name
		new.pressed.connect(emit_process_chosen.bind(pid))


func emit_process_chosen(pid: Alchemy.ProcessID) -> void:
	process_chosen.emit(pid)
