class_name Portal extends Node3D

@export var destination_path: StringName
@export var interactable: Interactable

func _ready() -> void:
	interactable.interacted.connect(_on_interact)

func _on_interact() -> void:
	SceneManager.change_active_scene_to_file(destination_path)
