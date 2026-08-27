class_name Customer extends Resource

var customer_type: String
var problem_severities: Dictionary[String, float]
var needs: Array[String]

const TYPE_TO_NEEDS_JSON_PATH: String = "res://scripts/customer/customer_type_to_need_probability.json"
const GAME_STAGE_TO_AILMENT_CHANCE_JSON_PATH: String = "res://scripts/customer/game_stage_to_ailment_chance.json"
##takes a potion as an argument and returns true if the potion will be accepted
## by this customer, otherwise false. A potion will be accepted if.. well, i'm
## not sure yet. TODO: update this function after the rest of the potion system
## is done
func check_potion_sufficient(potion: Potion) -> bool:
	return true

static func generate_customer() -> Customer:
	var customer = Customer.new()
	
	##getting json was a couple of lines, so i put it somewhere else.
	## should check for null here, but if it's null we probably want a
	## crash anyway.
	var type_to_needs_json: JSON = Utils.get_json(TYPE_TO_NEEDS_JSON_PATH)
	var customer_types = type_to_needs_json.data["NPC"]
	var customer_index = randi_range(0, customer_types.size()-1)
	customer.customer_type = customer_types[customer_index]
	print_debug(customer.customer_type)
	
	var ailment_chance_array: Array[float] = Utils.array_to_float_array(
		Utils.get_json(GAME_STAGE_TO_AILMENT_CHANCE_JSON_PATH).data["1"])
	var ailment_count: int = 0
	while(randf() < ailment_chance_array[ailment_count] and ailment_count < ailment_chance_array.size()):
		ailment_count+=1
	print_debug("%d ailments" % ailment_count)
	
	var ailments_array: Array = type_to_needs_json.data.keys()
	ailments_array.erase("NPC")
	var ailment_weights: Array
	ailment_weights.resize(ailments_array.size())
	for i in range(ailments_array.size()):
		ailment_weights[i] = type_to_needs_json.data[ailments_array[i]][customer_index]
	print_debug(ailments_array)
	print_debug(ailment_weights)
	
	var first_ailment: String = Utils.pick_random_weighted(ailments_array, Utils.array_to_float_array(ailment_weights))
	print_debug("first need is %s" % first_ailment)
	return customer

	
