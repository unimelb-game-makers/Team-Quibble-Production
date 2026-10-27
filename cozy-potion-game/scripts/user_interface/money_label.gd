class_name MoneyLabel extends Label


func _ready() -> void:
	PersistentInventory.money_changed.connect(_on_money_changed)
	text = " : " + str(PersistentInventory.money)

func _on_money_changed(new_money: int) -> void:
	text = " : " + str(new_money)
	var tween = create_tween()
	tween.tween_property(self,"scale", Vector2.ONE * 1.2, 0.1)
	tween.tween_property(self,"scale", Vector2.ONE, 0.1)
