extends Control

@export var minigame_packed_scenes: Array[PackedScene]

@onready var main_scene: Node = get_parent().get_parent() # ideally i would want a
# nice autoloader script to get the main scene


func _ready() -> void:
	for minigame_packed_scene in minigame_packed_scenes:
		$TestButton.add_item(minigame_packed_scene.instantiate().name)


func _on_play_button_pressed() -> void:
	# TODO
	main_scene.switch_scene(self, minigame_packed_scenes[0].instantiate())


func _on_test_button_item_selected(_index: int) -> void:
	if _index >= 2:
		main_scene.switch_scene(self, minigame_packed_scenes[_index - 2].instantiate())


func _on_quit_button_pressed() -> void:
	get_tree().quit()
