extends Node

@export var portal: Portal
@export var button: TextureButton
@export var player: WorldPlayer
@export var offset: Vector3


func _ready() -> void:
	button.pressed.connect(spawn)

func spawn() -> void:
	var tween = get_tree().create_tween()
	portal.scale = Vector3.ONE * 0.1
	tween.tween_property(portal, "scale", Vector3.ONE, 0.2)
	portal.global_position = player.position + offset
