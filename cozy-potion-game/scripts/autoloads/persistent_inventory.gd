extends Node

signal money_changed(new_money: float)
const PANTRY_SIZE = 40

var money: int = 200:
	set(value):
		money = value
		money_changed.emit(money)

@onready var pantry: Array[Stack] 
#= [Stack.new(1,Alchemy.ingredient_list.front())]

func add_stacks_to_pantry(stacks: Array[Stack]) -> void:
	pantry.append_array(stacks)
	pantry.resize(PANTRY_SIZE)
