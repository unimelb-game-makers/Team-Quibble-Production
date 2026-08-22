extends Node

@export var customer_anim_player: AnimationPlayer
@export var customer_interactable: InteractableArea
@export var customer: Customer
@export var dialogue_resource: DialogueResource

func _ready() -> void:
	send_customer()

func send_customer() -> void:
	customer_anim_player.play("person_in")
	customer_interactable.interacted.connect(_on_customer_interact, ConnectFlags.CONNECT_ONE_SHOT)
	customer.requested_potion_type = Potion.ATTRIBUTES.values().pick_random()
	customer.has_conveyed_request = false

func _on_customer_interact():
	if not customer.has_conveyed_request:
		#this is, generally, poor use of enums
		var dialogue_start: String = Potion.ATTRIBUTES.find_key(customer.requested_potion_type)
		dialogue_start = dialogue_start.to_lower()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
		customer.has_conveyed_request = true
		
