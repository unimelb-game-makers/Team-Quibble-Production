extends Node

@export var portal: Portal
@export var button: TextureButton
@export var player: WorldPlayer
@export var offset: Vector3


func _ready() -> void:
	button.pressed.connect(spawn)

func spawn() -> void:
	portal.animate_spawn()
	portal.global_position = player.position + offset
