class_name PortalPopup extends CanvasLayer

@export var yes_button: Button
@export var no_button: Button

signal no_clicked
signal yes_clicked

func _ready() -> void:
	yes_button.pressed.connect(yes_clicked.emit)
	no_button.pressed.connect(no_clicked.emit)
