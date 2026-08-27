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
	
	var json_string: String = FileAccess.open(TYPE_TO_NEEDS_JSON_PATH, FileAccess.READ).get_as_text()
	var json_data: JSON = JSON.new()

	assert(json_data.parse(json_string) == OK, 
			"Variable json_data was null. %s" % [json_data.get_error_message()])
	
	var customer_types = json_data.data["NPC"]
	var customer_index = randi_range(0, customer_types.size()-1)
	customer.customer_type = customer_types[customer_index]
	
	var ailment_chance_array = 
	
	return customer

	
