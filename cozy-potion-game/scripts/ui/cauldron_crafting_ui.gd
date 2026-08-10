extends CanvasLayer

@export var potion_brewer: PotionBrewing
@export var label_money_counter: Label
@export var container_recipe_list: VBoxContainer
@export var reset_button: Button
@export var make_button: Button
@export var quest_label: Label
@export var potion_created_container: PanelContainer
@export var potion_created_name_label: Label
@export var potion_created_value_label: Label

var player_money: int = 0 :
	get:
		return player_money
	set(_value):
		player_money = _value
		label_money_counter.text = "$%s" % player_money
		money_changed.emit(_value)

var current_potion: Array[PotionIngredient]
var ingredient_button: PackedScene = preload("uid://b6r6ktehhfb10")
var quest_amount: int = 100

signal money_changed(new_value: int)

func _ready() -> void:
	player_money = 0
	await potion_brewer.ready

	reset_button.pressed.connect(reset_potion)
	make_button.pressed.connect(create_potion)
	potion_created_container.gui_input.connect(_on_potion_created_container_gui_input)
	money_changed.connect(update_quest_text)

	for entry in potion_brewer.potion_ingredient_index.values():
		var ingredient: Button = ingredient_button.instantiate()
		ingredient.text = entry.name
		ingredient.pressed.connect(add_ingredient.bind(ingredient, entry))
		container_recipe_list.add_child(ingredient)

func add_ingredient(_pressed_button: Button, _ingredient: PotionIngredient) -> void:
	if current_potion.has(_ingredient):
		return

	if current_potion.size() >= 2:
		for button: Button in container_recipe_list.get_children():
			button.disabled = true

	print("Adding %s to potion" % _ingredient.name)
	current_potion.append(_ingredient)
	_pressed_button.disabled = true

func create_potion() -> void:
	if current_potion.size() == 0:
		return

	var created_potion := potion_brewer.attempt_brewing(current_potion)
	player_money += created_potion.value

	potion_created_container.show()
	potion_created_name_label.text = "You made a %s!" % created_potion.name
	potion_created_value_label.text = "(which you can sell for $%d.)" % created_potion.value
	
	reset_potion()


func reset_potion() -> void:
	current_potion.clear()

	for button: Button in container_recipe_list.get_children():
		button.disabled = false

#well, this is a bit wordy. Descriptive though!
func _on_potion_created_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		potion_created_container.hide()

func update_quest_text(money: int) -> void:
	if money >= quest_amount:
		quest_amount *= 2
	quest_label.text = "Get to $%d" % quest_amount
