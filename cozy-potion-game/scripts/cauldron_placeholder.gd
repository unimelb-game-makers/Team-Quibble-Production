extends Node3D

@export var interactable_area: InteractableArea

var i: int = 0
func _ready() -> void:
	interactable_area.interacted.connect(_on_interact)

#TODO change all of this. just delete this script tbh
func _on_interact():
	var player: WorldPlayer = get_tree().get_first_node_in_group("Player")
	var potion = Potion.new()
	player.potion = potion
	potion.type = i % Potion.ATTRIBUTES.size()
	potion.name = "Potion of %s" % Potion.ATTRIBUTES.find_key(potion.type)
	print_debug("You made a %s" % potion.name)
	i += 1
