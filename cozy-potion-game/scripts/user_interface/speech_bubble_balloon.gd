class_name SpeechBubbleBalloon extends DialogueManagerExampleBalloon

@export var balloon_control: Control
@export var default_position: Vector2
@export var balloon_rect: TextureRect
@export var flipped_position: Vector2
var wiggle_time: float
var wiggle_magnitude: float = 10
var wiggle_speed: float = 1


func randomize_wiggle():
	wiggle_time += randf()* PI

func set_severity_values(severity: float):
	randomize_wiggle()
	var normal_severity = severity/100
	wiggle_speed = 1 + 4 * normal_severity
	wiggle_magnitude = 5 + 5 * normal_severity
	balloon_control.scale = Vector2(0.8 + 0.4 * normal_severity, 0.8 + 0.4 * normal_severity)
	balloon_rect.self_modulate = lerp(Color(1.0, 1.0, 1.0, 1.0), Color(0.996, 0.703, 0.765, 1.0), normal_severity)

func _process(_delta: float) -> void:
	wiggle_time += _delta
	var wiggle_vector = Vector2(wiggle_position(wiggle_time), wiggle_position(wiggle_time + 2))
	balloon_control.offset_transform_position = wiggle_vector


func flip_x() -> void:
	balloon_rect.flip_h = true
	balloon_control.anchor_right = 1 - balloon_control.anchor_left
	balloon_control.anchor_left = 0


func flip_y() -> void:
	balloon_rect.flip_v = true
	balloon_rect.position.y = flipped_position.y

func wiggle_position(x: float) -> float:
	var sinsum = (sin(x* wiggle_speed) + cos(x * wiggle_speed)) / 2
	sinsum *= wiggle_magnitude
	return sinsum
