extends Node

@export var customer_anim_player: AnimationPlayer
@export var customer_interactable: Interactable
@export var customer_world: CustomerWorld
@export var dialogue_resource: DialogueResource

func _ready() -> void:
	send_customer()
	customer_interactable.interacted.connect(_on_customer_interact)
	customer_tests()

func send_customer() -> void:
	customer_anim_player.play("person_in")
	customer_world.has_conveyed_request = false

func recall_customer() -> void:
	customer_anim_player.play_backwards("person_in")
	await get_tree().create_timer(1).timeout
	send_customer()

func _on_customer_interact() -> void:
	if not customer_world.has_conveyed_request:
		#this is, generally, poor use of enums
		var dialogue_start: String = Potion.ATTRIBUTES.find_key(customer_world.customer.needs.front())
		dialogue_start = dialogue_start.to_lower()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
		customer_world.has_conveyed_request = true
	else:
		var player: WorldPlayer = get_tree().get_first_node_in_group(Utils.Group.GROUP_PLAYER)
		if customer_world.customer:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource, "accept")
			await DialogueManager.dialogue_ended
			player.potion = null
			recall_customer()
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource, "refuse")
			player.potion = null


#TODO:potions only have values and names, at the moment. This function will
#be updated once the potion system is.
func check_potion_match(player_potion: Potion, customer_request_type: Potion.ATTRIBUTES) -> bool:
	return true if randi_range(0,1) else false

func customer_tests():
	var test_customer_1: Customer = Customer.generate_customer()
	print_debug(test_customer_1.customer_type)
