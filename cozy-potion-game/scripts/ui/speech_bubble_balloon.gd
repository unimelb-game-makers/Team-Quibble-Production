class_name SpeechBubbleBalloon extends DialogueManagerExampleBalloon

@export var object_to_follow: Node3D
@export var balloon_control: Control
@export var default_position: Vector2

func _process(_delta: float) -> void:
	if object_to_follow:
		balloon_control.global_position = get_viewport().get_camera_3d().unproject_position(object_to_follow.global_position)
	else:
		balloon_control.global_position = default_position
