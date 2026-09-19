class_name Customer extends Resource

enum CustomerID{
	NPC_STUDENT,
	NPC_COURIER,
	NPC_WIZARD,
	NPC_WITCH,
	NPC_BAKER,
	NPC_LUMBERJACK,
	NPC_HUNTER,
	NPC_HERBALIST,
	NPC_ARTIST,
	NPC_COMEDIAN,
	NPC_MUSICIAN,
	NPC_TAXI_DRIVER,
	NPC_RAVER,
	NPC_CULTIST,
	NPC_CORPORATE_MAGE,
	NPC_MONSTER_CONTROL,
	NPC_CONSTRUCTION_WORKER,
	NPC_APPRENTICE_WIZARD,
	NPC_RUNE_PROGRAMMER,
	NPC_PRIVATE_INVESTIGATOR,
}
##customer occupation: student, cultist, etc
var customer_id: CustomerID
##array of customer needs: NEED_HEALING, NEED_LIGHT, etc
##the first element is the primary need, others are secondary
var needs: Array[Alchemy.NeedID]
##each element in needs has a corresponding severity in this array at
##the same index.
var need_severities: Array[float]
##the first need. Ooh, that souds philosophical. root of all desires and shit.
var primary_need: Alchemy.NeedID:
	get():
		return needs.front()
	#this isn't neccessary
	set(value):
		needs[0] = value

var secondary_need: Alchemy.NeedID:
	get():
		if needs.size() < 2:
			return -1
		return needs.back()
	#this isn't neccessary
	set(value):
		needs.insert(1, value)

##how much time a customer will progress the day by when satisfied
var time_allotment: float

const TYPE_TO_NEEDS_JSON_PATH: String = "res://scripts/customer/customer_type_to_need_probability.json"
const GAME_STAGE_TO_AILMENT_CHANCE_JSON_PATH: String = "res://scripts/customer/game_stage_to_ailment_chance.json"
const AILMENT_RELATIONSHIP_JSON_PATH: String = "res://scripts/customer/ailment_relationships.json"
const GAME_STAGE_1_SEVERITY_CURVE: String = "res://scripts/customer/game_stage_1_severity_curve.tres"

##takes a potion as an argument and returns true if the potion will be accepted
## by this customer, otherwise false. A potion will be accepted if.. well, i'm
## not sure yet. TODO: update this function after the rest of the potion system
## is done
func check_potion_sufficient(potion: Potion) -> bool:
	var match_primary = Alchemy.attribute_to_need_index[potion.potion_primary] == primary_need
	var match_secondary = true
	if secondary_need >= 0:
		Alchemy.attribute_to_need_index[potion.potion_secondary] == secondary_need
	
	return match_primary and match_secondary


##Returns a randomly created customer resource. 
## if set_type isn't null, it's type will always be that
## if debug is true, print debug information
static func generate_customer(set_type: CustomerID = -1, DEBUG: bool = false) -> Customer:
	var customer_resource = Customer.new()
	
	#These first lines initialise the json mapping character types to need
	# probabilities, create a customer, and set its type randomly
	var type_to_needs_json: JSON = Utils.get_json(TYPE_TO_NEEDS_JSON_PATH)
	var customers: Array = type_to_needs_json.data
	
	#once we choose a customer randomly or not, their json data is put
	#here. This is not the customer resource.
	var customer_dictionary: Dictionary
	if set_type < 0:
		customer_dictionary = get_random_customer(customers)
		customer_resource.customer_id = CustomerID.keys().find(customer_dictionary.get("NPC")) as CustomerID
	else:
		for dict in customers:
			if dict.get("NPC") == CustomerID.find_key(set_type):
				customer_dictionary = dict
				customer_resource.customer_id = set_type
				break
		
		assert(customer_dictionary, "set customer type does not exist")
		
	if DEBUG:
		print_debug("Customer type: %s" % customer_resource.customer_id)
	
	#TODO: allow for more game stages
	var need_count = get_need_count(DEBUG)
	
	set_needs(customer_dictionary, customer_resource, need_count, DEBUG)
	
	#TODO: allow for more game stages
	set_need_severities(customer_resource, need_count, DEBUG)

	return customer_resource

static func set_needs(customer_dictionary: Dictionary, customer_resource: Customer, need_count: int, DEBUG) -> void:
	var ailments_array: Array = customer_dictionary.keys()
	ailments_array = ailments_array.filter(func(x): return x.begins_with("NEED_"))
	
	var ailment_weights: Array[float]
	ailment_weights.resize(ailments_array.size())
	var effect: NewsEvent.NewsEffect = NewsManager.get_news_effect("NEED_PROBABILITY")
	for i in range(ailments_array.size()):
		ailment_weights[i] = float(customer_dictionary.get(ailments_array[i]))
		if effect and effect.target == ailments_array[i]:
			ailment_weights[i] *= effect.magnitude
		
	if DEBUG:
		print_debug("Ailments: ", ailments_array)
		print_debug("Ailment Weights: ", ailment_weights)
	
	var first_ailment: String = Utils.pick_random_weighted(ailments_array, Utils.array_to_float_array(ailment_weights))
	var first_need_id: Alchemy.NeedID = Alchemy.NeedID.keys().find(first_ailment)
	customer_resource.needs.append(first_need_id)
	if DEBUG:
		print_debug("first need is %s" % first_ailment)
	
	var ailment_relationship_json: JSON = Utils.get_json(AILMENT_RELATIONSHIP_JSON_PATH)
	
	var secondary_ailment_array: Array
	var secondary_ailment_weights: Array[float]
	#look for matching row
	for dict in ailment_relationship_json.data:
		if dict.get("ROW_OF_NEEDS") == first_ailment:
			secondary_ailment_array = dict.keys()
			secondary_ailment_array = secondary_ailment_array.filter(func(x): return x.begins_with("NEED_"))
			for ailment in secondary_ailment_array:
				var val: float = float(dict.get(ailment))
				if effect and effect.target == ailment:
					val *= effect.magnitude
				
				secondary_ailment_weights.append(val)
	
	var j: int = need_count
	while (j > 1):
		j -= 1
		var secondary_ailment = Utils.pick_random_weighted(secondary_ailment_array, Utils.array_to_float_array(secondary_ailment_weights))
		var secondary_need_id: Alchemy.NeedID = Alchemy.NeedID.keys().find(secondary_ailment)
		customer_resource.needs.append(secondary_need_id)
		
		#remove this index from the list
		var index = secondary_ailment_array.find(secondary_ailment)
		secondary_ailment_array.remove_at(index)
		secondary_ailment_weights.remove_at(index)
		if DEBUG:
			print_debug("additional need is %s" % secondary_ailment)
	
static func get_need_count(DEBUG) -> int:
	var need_chance_array: Array[float] = Utils.array_to_float_array(
		Utils.get_json(GAME_STAGE_TO_AILMENT_CHANCE_JSON_PATH).data["1"])
	var need_count: int = 0
	while(randf() < need_chance_array[need_count] and need_count < need_chance_array.size()):
		need_count+=1
		if need_count >= 2:
			break;
	if DEBUG:
		print_debug("%d needs" % need_count)
	return need_count
	
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
	

static func get_random_customer(customers: Array) -> Dictionary:
	var customer_weights: Array[float]
	var effect: NewsEvent.NewsEffect = NewsManager.get_news_effect("NPC_SPAWN_PROBABILITY")
	for dict in customers:
		var val = float(dict.get("NPC_SPAWN_PROBABILITY"))
		if effect and dict.get("NPC") == effect.target:
			val *= effect.magnitude
		customer_weights.append(val)
	return Utils.pick_random_weighted(customers, customer_weights)
	

		
	
