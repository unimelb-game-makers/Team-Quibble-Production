## exists to make the day start when the shop loads, not on scene ready
class_name DayStarter extends Node

static var fired: bool = false
static var show_initial_tutorial: bool = false

func _ready() -> void:
	await get_tree().process_frame

	if SaveManager.restoring_session:
		fired = true
		return

	if not fired:
		fired = true
		TimeCycle.start_day()

	if show_initial_tutorial:
		show_initial_tutorial = false

		var popup: PopupSubWindow = get_tree().get_first_node_in_group("popup_subwindow")
		if popup:
			Notebook.open_notebook(popup)
