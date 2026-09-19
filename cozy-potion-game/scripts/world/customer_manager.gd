extends Node

@export var customer_anim_player: AnimationPlayer
@export var customer_interactable: Interactable
@export var customer_world: CustomerWorld
@export var dialogue_resource: DialogueResource
@export var acceptor_dialogue_balloon: PackedScene

var customer_queue: Array[Customer]

func _ready() -> void:
	customer_tests()
	
	customer_interactable.interacted.connect(_on_customer_interact)
	TimeCycle.day_started.connect(_on_day_started)


#runs at the start of the day and sets up the list of customers and
#also sends the first one to the shop
func _on_day_started() -> void:
	#this await is so that the news manager, which generates
	#news at the start of the day, has time to do that
	#before we need to use it here
	await get_tree().create_timer(1).timeout
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

func _on_customer_interact(fuck, this) -> void:
	if not customer_world.has_conveyed_request:
		DialogueManager.show_example_dialogue_balloon(CustomerDialogue.get_initial_dialogue(customer_world.customer), "start")
		customer_world.has_conveyed_request = true
		Utils.corner_needs_list_manager.create_list(customer_world.customer)
	else:
		show_acceptor_dialogue("start_accepting")

func show_acceptor_dialogue(dialogue_start: String) -> void:
	DialogueManager.show_dialogue_balloon_scene(acceptor_dialogue_balloon, dialogue_resource, dialogue_start)
	if DialogueManager.active_balloon is ItemAcceptDialogueBalloon:
		var potion_accept_zone: CustomerPotionAcceptZone = DialogueManager.active_balloon.potion_accept_zone
		potion_accept_zone.draggable_acceptor_compoment.accepted_draggable.connect(_on_acceptor_accepted)
	else:
		assert(false)

func _on_acceptor_accepted(control: Control):
	DialogueManager.active_balloon.queue_free()
	
	if not control is ItemSlot:
		DraggableComponent.get_draggable_component(control).return_to_previous()
	
	var item = control.stack.item
	
	if not item is Potion:
		DraggableComponent.get_draggable_component(control).return_to_previous()
		other_accepted()
		return
	
	if customer_world.customer.check_potion_sufficient(item):
		buy_potion(item)
	else:
		DraggableComponent.get_draggable_component(control).return_to_previous()
		refuse_potion()

func other_accepted():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, "not_potion")

func buy_potion(potion: Potion) -> void:
		Utils.corner_needs_list_manager.clear_list()
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, "accept")
		await DialogueManager.dialogue_ended
		if customer_world.customer.time_allotment:
			TimeCycle.progress_day(customer_world.customer.time_allotment)
		else:
			TimeCycle.progress_day()
		recall_customer()

func refuse_potion() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, "refuse")
	

#generates some number of customers to be drawn from during the day
func generate_customer_queue() -> void:
	for i in range(TimeCycle.customers_per_day):
		customer_queue.append(Customer.generate_customer())
	
	var time_allotments = generate_customer_time_allotments()
	for i in range(time_allotments.size()):
		customer_queue[i].time_allotment = time_allotments[i]

func generate_customer_time_allotments() -> Array[float]:
	var customer_time_allotments: Array[float]
	#randomly puts a number of points on a line from 0 to 1 equal to the number 
	#of customers per day minus 1. This leaves a number of gaps between points
	#on that number line equal to the number of customers.
	#those gaps are then assigned to the customer time array.
	var points: Array[float]
	for i in range(TimeCycle.customers_per_day-1):
		points.append(randf_range(0, 1))
	
	points.sort()
	customer_time_allotments.append(points.front())
	
	for i in range(1, TimeCycle.customers_per_day-1):
		customer_time_allotments.append(points[i] - points[i-1])
	
	#a little bit of padding is added to this value to ensure that it ends the day
	customer_time_allotments.append(1.1-points.back())
	return customer_time_allotments

#gets the next customer of the day, or else null
func get_next_customer() -> Customer:
	return customer_queue.pop_front()
	
func customer_tests() -> void:
	var test_customer_1: Customer = Customer.generate_customer(-1, false)
	assert(test_customer_1.customer_id >= 0, "bad customer 1")
	assert(test_customer_1.needs.size() > 0, "bad customer 1")
	var test_customer_2: Customer = Customer.generate_customer(Customer.CustomerID.NPC_STUDENT, false)
	assert(test_customer_2.customer_id == Customer.CustomerID.NPC_STUDENT, "bad customer 2")
	assert(test_customer_2.needs.size() > 0, "bad customer 2")

	print_debug(CustomerDialogue.get_potion_request_line(test_customer_2).text)


	
