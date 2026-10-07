class_name Portal extends Node3D

@export var destination_path: StringName
@export var interactable: Interactable
@export var player_spawn_position: Marker3D

static var spawn_at_portal: bool = false

func _ready() -> void:
	interactable.interacted.connect(_on_interact)

func _on_interact() -> void:
	spawn_at_portal = true
	SceneManager.change_active_scene_to_file(destination_path, SceneManager.TRANSITIONS.FADE)
