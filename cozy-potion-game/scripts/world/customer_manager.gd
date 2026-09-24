extends Node

@export var customer_anim_player: AnimationPlayer
@export var customer_interactable: Interactable
@export var customer_world: CustomerWorld
@export var dialogue_resource: DialogueResource
@export var acceptor_dialogue_balloon: PackedScene
@export var speech_bubble_dialogue_balloon: PackedScene

var customer_queue: Array[Customer]
var can_force_potion_to_customer: bool = false

func _ready() -> void:
	customer_tests()
	DialogueManager.dialogue_started.connect(func(idk = null): can_force_potion_to_customer = true)
	DialogueManager.dialogue_ended.connect(func(idk = null): can_force_potion_to_customer = false)
	customer_interactable.interacted.connect(_on_customer_interact)
	TimeCycle.day_started.connect(_on_day_started)
	var crack
	DevTools.PLEASE_FUCKOFF.connect(buy_potion.bind(crack))

func _unhandled_input(_event: InputEvent) -> void:
	if !can_force_potion_to_customer:
		return

	if DraggableComponent.dragged_control != null:
		_on_acceptor_accepted(DraggableComponent.dragged_control)
		return

	if ClickableComponent.dragged_control != null:
		_on_acceptor_accepted(ClickableComponent.dragged_control)
		return

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("close_minigame") or event.is_action_pressed("ui_accept"):
		#
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
	Utils.corner_needs_list_manager.create_list(customer_world.customer)

func recall_customer() -> void:
	customer_anim_player.play_backwards("person_in")
	await get_tree().create_timer(1).timeout
	send_customer()

func _on_customer_interact() -> void:
	show_acceptor_dialogue()


func show_acceptor_dialogue() -> void:
	var customer = customer_world.customer
	var balloons: Array[SpeechBubbleBalloon]
	# Display dialogue for first request
	var request_dialogue_resource = CustomerDialogue.get_potion_request_line(customer.primary_need, customer.customer_id)
	var balloon: SpeechBubbleBalloon = DialogueManager.show_dialogue_balloon_scene(acceptor_dialogue_balloon, request_dialogue_resource,"start")
	balloons.append(balloon)
	balloon.set_severity_values(customer.need_severities.front())
	
	# Display dialogue for second request if able, and shift that dialogue's position
	if customer.secondary_need >= 0:
		request_dialogue_resource = CustomerDialogue.get_potion_request_line(customer.secondary_need, customer.customer_id)
		balloon = DialogueManager.show_dialogue_balloon_scene(speech_bubble_dialogue_balloon, request_dialogue_resource,"start")
		balloons.append(balloon)
		balloon.flip_x()
		balloon.set_severity_values(customer.need_severities.back())
	
	# Oh my
	var free_all = func(x: Array): for i in x: if is_instance_valid(i): i.queue_free()
	for balloon_enumerated in balloons:
		balloon_enumerated.tree_exited.connect(free_all.bind(balloons))
	var acceptor_balloon = balloons.front()
	if acceptor_balloon is ItemAcceptDialogueBalloon:
		var potion_accept_zone: CustomerPotionAcceptZone = acceptor_balloon.potion_accept_zone
		potion_accept_zone.draggable_acceptor_compoment.accepted_draggable.connect(_on_acceptor_accepted)
	else:
		assert(false)

const DYLAN = 1
const RAMSEY = 2

func nightmare(control: Control) -> int:
	if DraggableComponent.get_draggable_component(control) != null:
		return RAMSEY
	
	if ClickableComponent.dragged_control == control:
		return DYLAN
	return 1
		

func _on_acceptor_accepted(control: Control):
	DialogueManager.active_balloon.queue_free()
	
	if not control is ItemHolder:
		if nightmare(control) == RAMSEY:
			DraggableComponent.get_draggable_component(control).return_to_previous()
		else:
			ClickableComponent.the_cunt.stop_dragging()
	
	if control.stack == null:
		return
	
	if control.stack.item == null:
		return

	var item = control.stack.item
	
	if not item is Potion:
		if nightmare(control) == RAMSEY:
			DraggableComponent.get_draggable_component(control).return_to_previous()
		else:
			ClickableComponent.the_cunt.die()
		other_accepted()
		return
	
	if customer_world.customer.check_potion_sufficient(item):
		if nightmare(control) == RAMSEY:
			DraggableComponent.get_draggable_component(control).return_to_previous()
		else:
			ClickableComponent.the_cunt.die()
		buy_potion(item)
	else:
		if nightmare(control) == RAMSEY:
			DraggableComponent.get_draggable_component(control).return_to_previous()
		else:
			ClickableComponent.the_cunt.die()
		refuse_potion()

func other_accepted():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, "not_potion")

func buy_potion(potion: Potion) -> void:

	Utils.corner_needs_list_manager.clear_list()
	DialogueManager.show_dialogue_balloon_scene(speech_bubble_dialogue_balloon, dialogue_resource, "accept")
	await DialogueManager.dialogue_ended
	if customer_world.customer.time_allotment:
		TimeCycle.progress_day(customer_world.customer.time_allotment)
	else:
		TimeCycle.progress_day()
	recall_customer()

func refuse_potion() -> void:
		DialogueManager.show_dialogue_balloon_scene(speech_bubble_dialogue_balloon,dialogue_resource, "refuse")
	

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
	var test_customer_1: Customer = Customer.generate_customer(-1)
	assert(test_customer_1.customer_id >= 0, "bad customer 1")
	assert(test_customer_1.needs.size() > 0, "bad customer 1")
	var test_customer_2: Customer = Customer.generate_customer(Customer.CustomerID.NPC_STUDENT)
	assert(test_customer_2.customer_id == Customer.CustomerID.NPC_STUDENT, "bad customer 2")
	assert(test_customer_2.needs.size() > 0, "bad customer 2")


	
