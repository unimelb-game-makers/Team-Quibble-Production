extends Node

signal money_changed(new_money: float)
const PANTRY_SIZE = 40

var money: int:
	set(value):
		money = value
		money_changed.emit(money)

var pantry: Array[Stack]

func add_stacks_to_pantry(stacks: Array[Stack]) -> void:
	pantry.append_array(stacks)
	pantry.resize(PANTRY_SIZE)
