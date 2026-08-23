extends Minigame

func _ready() -> void:
	$CanvasLayer.potion_made.connect(win_minigame)
