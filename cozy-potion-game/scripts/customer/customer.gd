class_name Customer extends Resource

##customer occupation: student, cultist, etc
var customer_type: String
##array of customer needs: NEED_HEALING, NEED_LIGHT, etc
##the first element is the primary need, others are secondary
var needs: Array[String]
##each element in needs has a corresponding severity in this array at
##the same index.
var need_severities: Array[float]
##the first need. Ooh, that souds philosophical. root of all desires and shit.
var primary_need: String:
	get():
		return needs.front()
	#this isn't neccessary
	set(value):
		assert(value is String, "tried to set nonstring primary need")
		needs[0] = value


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


##Returns a randomly created customer resource. 
## if set_type isn't null, it's type will always be that
## if debug is true, print debug information
static func generate_customer(set_type: String = "", DEBUG: bool = false) -> Customer:
	var customer = Customer.new()
	
	#These first lines initialise the json mapping character types to need
	# probabilities, create a customer, and set its type randomly
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
	var ailment_count = get_ailment_count(customer, DEBUG)
	
	set_ailments(customer, customer_index, ailment_count, type_to_needs_json,DEBUG)
	
	#TODO: allow for more game stages
	set_need_severities(customer, ailment_count, DEBUG)

	return customer

static func set_ailments(customer, customer_index, ailment_count, json, DEBUG) -> void:
	var ailments_array: Array = json.data.keys()
	ailments_array.erase("NPC")
	var ailment_weights: Array
	ailment_weights.resize(ailments_array.size())
	for i in range(ailments_array.size()):
		ailment_weights[i] = json.data[ailments_array[i]][customer_index]
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
	
static func get_ailment_count(customer, DEBUG) -> int:
	var ailment_chance_array: Array[float] = Utils.array_to_float_array(
		Utils.get_json(GAME_STAGE_TO_AILMENT_CHANCE_JSON_PATH).data["1"])
	var ailment_count: int = 0
	while(randf() < ailment_chance_array[ailment_count] and ailment_count < ailment_chance_array.size()):
		ailment_count+=1
	if DEBUG:
		print_debug("%d ailments" % ailment_count)
	return ailment_count
	
static func set_need_severities(customer: Customer, ailment_count: int, DEBUG: bool) -> void:
	var severity_curve: Curve = preload(GAME_STAGE_1_SEVERITY_CURVE)
	var first_ailment_severity = severity_curve.sample(randf())
	customer.need_severities.resize(ailment_count)
	customer.need_severities[0] = first_ailment_severity
	for i in range(ailment_count):
		if i > 0:
			customer.need_severities[i] = first_ailment_severity/2
	
	if DEBUG:
		print_debug("need severities: ", customer.need_severities)
	
