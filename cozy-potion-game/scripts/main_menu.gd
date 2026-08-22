extends Control

@export var minigame_packed_scenes: Array[PackedScene]

@onready var main_scene: Node = get_parent().get_parent() # ideally i would want a
# nice autoloader script to get the main scene

@onready var shop_scene_path := "uid://bec7ovcvsvc5q"


func _ready() -> void:
	for minigame_packed_scene in minigame_packed_scenes:
		$TestButton.add_item(minigame_packed_scene.instantiate().name)


func _on_play_button_pressed() -> void:
	# TODO
	SceneManager.change_active_scene_to_file(shop_scene_path)


func _on_test_button_item_selected(_index: int) -> void:
	if _index >= 2:
		SceneManager.change_active_scene_to_packed(minigame_packed_scenes[_index - 2])


func _on_quit_button_pressed() -> void:
	get_tree().quit()
