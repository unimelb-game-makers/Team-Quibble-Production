class_name Customer extends Resource

var customer_type: String
var need_severities: Array[float]
var needs: Array[String]

const TYPE_TO_NEEDS_JSON_PATH: String = "res://scripts/customer/customer_type_to_need_probability.json"
const GAME_STAGE_TO_AILMENT_CHANCE_JSON_PATH: String = "res://scripts/customer/game_stage_to_ailment_chance.json"
const AILMENT_RELATIONSHIP_JSON_PATH: String = "res://scripts/customer/ailment_relationships.json"
const GAME_STAGE_1_SEVERITY_CURVE: String = "res://scripts/customer/game_stage_1_severity_curve.tres"

##takes a potion as an argument and returns true if the potion will be accepted
## by this customer, otherwise false. A potion will be accepted if.. well, i'm
## not sure yet. TODO: update this function after the rest of the potion system
## is done
func check_potion_sufficient(potion: Potion) -> bool:
	return true

static func generate_customer(set_type: String = "", DEBUG: bool = false) -> Customer:
	var customer = Customer.new()
	
	#getting json was a couple of lines, so i put it somewhere else.
	# should check for null here, but if it's null we probably want a
	# crash anyway.
	var type_to_needs_json: JSON = Utils.get_json(TYPE_TO_NEEDS_JSON_PATH)
	var customer_types: Array = type_to_needs_json.data["NPC"]
	var customer_index: int
	if set_type == "":
		customer_index = randi_range(0, customer_types.size()-1)
		customer.customer_type = customer_types[customer_index]
	else:
		assert(customer_types.has(set_type), "Attempted to spawn unknown customer")
		customer_index = customer_types.find(set_type)
		customer.customer_type = set_type
	if DEBUG:
		print_debug(customer.customer_type)
	
	#TODO: allow for more game stages
	var ailment_chance_array: Array[float] = Utils.array_to_float_array(
		Utils.get_json(GAME_STAGE_TO_AILMENT_CHANCE_JSON_PATH).data["1"])
	var ailment_count: int = 0
	while(randf() < ailment_chance_array[ailment_count] and ailment_count < ailment_chance_array.size()):
		ailment_count+=1
	if DEBUG:
		print_debug("%d ailments" % ailment_count)
	
	var ailments_array: Array = type_to_needs_json.data.keys()
	ailments_array.erase("NPC")
	var ailment_weights: Array
	ailment_weights.resize(ailments_array.size())
	for i in range(ailments_array.size()):
		ailment_weights[i] = type_to_needs_json.data[ailments_array[i]][customer_index]
	if DEBUG:
		print_debug(ailments_array)
		print_debug(ailment_weights)
	
	var first_ailment: String = Utils.pick_random_weighted(ailments_array, Utils.array_to_float_array(ailment_weights))
	customer.needs.append(first_ailment)
	if DEBUG:
		print_debug("first need is %s" % first_ailment)
	
	var ailment_relationship_json: JSON = Utils.get_json(AILMENT_RELATIONSHIP_JSON_PATH)
	var secondary_ailment_array: Array = ailment_relationship_json.data["Need B"]
	var secondary_ailment_weights: Array = ailment_relationship_json.data[first_ailment]
	var j: int = ailment_count
	while (j > 1):
		j -= 1
		var secondary_ailment = Utils.pick_random_weighted(secondary_ailment_array, Utils.array_to_float_array(secondary_ailment_weights))
		customer.needs.append(secondary_ailment)
		
		#remove this index from the list
		var index = secondary_ailment_array.find(secondary_ailment)
		secondary_ailment_array.remove_at(index)
		secondary_ailment_weights.remove_at(index)
		if DEBUG:
			print_debug("additional need is %s" % secondary_ailment)
	
	#currently, i am setting ailment severities by sampling randomly along a curve
	#i did it this way because it allows for fine tuning of exactly how
	#severe we want problems to be at each stage. 
	#also, additional ailments past the first have half severity of 
	# the first.
	#TODO: allow for more game stages
	var severity_curve: Curve = preload(GAME_STAGE_1_SEVERITY_CURVE)
	var first_ailment_severity = severity_curve.sample(randf())
	customer.need_severities.resize(ailment_count)
	customer.need_severities[0] = first_ailment_severity
	for i in range(ailment_count):
		if i > 0:
			customer.need_severities[i] = first_ailment_severity/2
	
	if DEBUG:
		print_debug("need severities: ", customer.need_severities)
	return customer

	
