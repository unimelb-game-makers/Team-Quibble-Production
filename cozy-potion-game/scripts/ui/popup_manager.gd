extends CanvasLayer
class_name PopupManager

var popup_text_scene: PackedScene = preload("res://scenes/user_interface/popup_text.tscn")

func _ready() -> void:
	Utils.popup_manager = self

func spawn_popup(node: Node3D, text: String = "E to interact") -> PopupText:
	var popup: PopupText = popup_text_scene.instantiate()
	add_child(popup)
	popup.initialize(node, text)
	return popup
