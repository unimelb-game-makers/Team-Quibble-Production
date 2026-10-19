class_name MoneyDisplay extends CanvasLayer

@export var label: Label

var internal_money: float
var internal_money_target: int

func _ready() -> void:
	PersistentInventory.money_changed.connect(update_money)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("K"):
		PersistentInventory.money += 50

func _process(delta: float) -> void:
	if not is_equal_approx(internal_money, internal_money_target):
		internal_money += (internal_money_target-internal_money) * 2 * delta
		if abs(internal_money_target - internal_money) < 0.5:
			internal_money = internal_money_target
		_update_money_internal(internal_money)

func update_money(new_money: int):
	internal_money_target = new_money

func _update_money_internal(money: float):
	money = int(money)
	var money_string = ":"
	# Not doing this smartly
	if money > 999:
		money /= 1000
		money_string += "%.0dk" % money
	else:
		money_string += "%.0d" % money
	
	label.text = money_string
