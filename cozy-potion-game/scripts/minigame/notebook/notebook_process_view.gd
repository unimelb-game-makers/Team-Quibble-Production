extends Node

@onready var notebook_item_display: NotebookProcessDisplay = $NotebookProcessDisplay
@onready var process_list: ProcessList = $MarginContainer/ProcessList


func _ready() -> void:
	set_process_display(process_list.PROCESS_LISTED[0])
	process_list.process_chosen.connect(set_process_display)


func set_process_display(pid : Alchemy.ProcessID) -> void:
	notebook_item_display.set_process_display(pid)
