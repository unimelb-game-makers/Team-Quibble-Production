extends Node

signal money_changed(new_money: float)

var money: int:
	set(value):
		money = value
		money_changed.emit(money)

var pantry: Array[Stack]
