extends Minigame

#signal potion_made

@export var potion_brewer: PotionBrewing
@export var reset_button: Button
@export var make_button: Button
@export var potion_created_container: PanelContainer
@export var potion_created_name_label: Label
@export var potion_created_value_label: Label

var ingredient_button: PackedScene = preload("uid://b6r6ktehhfb10")

#signal money_changed(new_value: int)

func _ready() -> void:
	# await potion_brewer.ready

	#reset_button.pressed.connect(reset_potion)
	make_button.pressed.connect(create_potion)
	potion_created_container.gui_input.connect(_on_potion_created_container_gui_input)

func create_potion() -> void:
	

	if PotionBrewing.recipe.size() == 0:
		return

	var created_potion := potion_brewer.attempt_brewing(PotionBrewing.recipe)

	potion_created_container.show()
	potion_created_name_label.text = "You made a %s!" % created_potion.name
	potion_created_value_label.text = "(which you can sell for $%d.)" % created_potion.value
	
	get_tree().get_first_node_in_group(Utils.Group.GROUP_PLAYER).potion = created_potion
	#reset_potion()


#func reset_potion() -> void:
	#current_potion.clear()

#well, this is a bit wordy. Descriptive though!
func _on_potion_created_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		potion_created_container.hide()
		PotionBrewing.recipe.clear()
		minigame_won.emit()
