extends Node

@export var customer_anim_player: AnimationPlayer
@export var customer_interactable: Interactable
@export var customer_world: CustomerWorld
@export var dialogue_resource: DialogueResource

var customer_queue: Array[Customer]


func _ready() -> void:
	customer_interactable.interacted.connect(_on_customer_interact)
	customer_tests()
	TimeCycle.day_started.connect(_on_day_started)

#runs at the start of the day and sets up the list of customers and
#also sends the first one to the shop
func _on_day_started() -> void:
	#this await is so that the news manager, which generates
	#news at the start of the day, has time to do that
	#before we need to use it here
	await get_tree().process_frame
	generate_customer_queue()
	send_customer()

func send_customer() -> void:
	customer_world.customer = get_next_customer()
	if not customer_world.customer :
		return
		
	customer_anim_player.play("person_in")
	customer_world.has_conveyed_request = false

func recall_customer() -> void:
	customer_anim_player.play_backwards("person_in")
	await get_tree().create_timer(1).timeout
	send_customer()

func _on_customer_interact() -> void:
	if not customer_world.has_conveyed_request:
		
		DialogueManager.show_example_dialogue_balloon(CustomerDialogue.get_initial_dialogue(customer_world.customer), "start")
		customer_world.has_conveyed_request = true
	else:
		var player: WorldPlayer = get_tree().get_first_node_in_group(Utils.Group.GROUP_PLAYER)
		if customer_world.customer.check_potion_sufficient(player.potion):
			DialogueManager.show_example_dialogue_balloon(dialogue_resource, "accept")
			await DialogueManager.dialogue_ended
			player.potion = null
			TimeCycle.progress_day()
			recall_customer()
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource, "refuse")
			player.potion = null

#generates some number of customers to be drawn from during the day
# plus some morein case something bad happens. idk
func generate_customer_queue() -> void:
	for i in range(TimeCycle.customers_per_day + 3):
		customer_queue.append(Customer.generate_customer())

#gets the next customer of the day, or else null
func get_next_customer() -> Customer:
	return customer_queue.pop_front()
	
func customer_tests() -> void:
	var test_customer_1: Customer = Customer.generate_customer()
	assert(test_customer_1.customer_type != "", "bad customer 1")
	assert(test_customer_1.needs.size() > 0, "bad customer 1")
	assert(test_customer_1.needs[0] != "", "bad customer 1")
	var test_customer_2: Customer = Customer.generate_customer("Student")
	assert(test_customer_2.customer_type == "Student", "bad customer 2")
	assert(test_customer_2.needs.size() > 0, "bad customer 2")
	assert(test_customer_2.needs[0] != "", "bad customer 2")


	
