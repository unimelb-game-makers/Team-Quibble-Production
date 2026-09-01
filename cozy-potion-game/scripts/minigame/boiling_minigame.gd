extends Minigame

@export var progress_variance_array: Array[Curve]
@onready var progress_variance: Curve = progress_variance_array.pick_random()

@onready var boiling_timer: Timer = $BoilingTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SUCCESS_AREA_START: float = 0.8
const SUCCESS_AREA_END: float = 0.9

const THERMOMETER_WIDTH: float = 960 # this and the above will be replaced by assets anyway

const TOTAL_TIME: float = 5.0


func _ready() -> void:
	$Thermometer.texture.gradient.offsets = [0.0, SUCCESS_AREA_START, SUCCESS_AREA_END]

func _process(_delta: float) -> void:
	if !boiling_timer.is_stopped():
		var progress: float = progress_variance.sample((TOTAL_TIME - boiling_timer.time_left) / TOTAL_TIME)
		$Thermometer/Needle.position.x = (progress - 0.5) * THERMOMETER_WIDTH
		if Input.is_action_just_pressed(&"interact") or Input.is_action_just_pressed(&"LMB"):
			boiling_timer.stop()
			if progress < SUCCESS_AREA_END and progress > SUCCESS_AREA_START:
				## TODO: presumably returns null ingredients
				pass
			else:
				pass
			animation_player.play(&"end")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		&"start":
			$Thermometer/Needle.show()
			boiling_timer.start(TOTAL_TIME)
		&"end":
			win_minigame()
