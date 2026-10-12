extends CanvasLayer

signal forced_customer_leave

@export var customer_leave_button: Button

func _ready() -> void:
	visible = false
	customer_leave_button.pressed.connect(leave)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_console"):
		visible = !visible

func leave():
	forced_customer_leave.emit()
