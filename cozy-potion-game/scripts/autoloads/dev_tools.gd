extends CanvasLayer

signal PLEASE_FUCKOFF

@export var customer_fuck_off: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	customer_fuck_off.pressed.connect(fuck_off)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_console"):
		visible = !visible

func fuck_off():
	PLEASE_FUCKOFF.emit()