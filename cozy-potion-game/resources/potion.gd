class_name Potion
extends Resource

var potion_name: String = "Inert Potion"
var potion_value: int = 0

var potion_id: Alchemy.PotionID = Alchemy.PotionID.size()
var potion_primary: Alchemy.AttributeID = Alchemy.AttributeID.size()
var potion_secondary: Alchemy.AttributeID = Alchemy.AttributeID.size()
var potion_attribute_strength: int

func constructor(_attributes: Dictionary[Alchemy.AttributeID, int]) -> void:
	var keys := _attributes.keys()
	keys.sort_custom(func(a, b): return _attributes[a] > _attributes[b])
	
	for key in keys:
		print("%s:%s" % [Alchemy.AttributeID.keys()[key], _attributes[key]])
		
	potion_id = keys[0]
	potion_primary = keys[0]
	if _attributes[keys[0]] == _attributes[keys[1]]:
		potion_secondary = keys[1]
		
	potion_attribute_strength = _attributes[keys[0]]
	
	potion_name = "Potion of " + Alchemy.AttributeID.keys()[0].trim_prefix("ATTR_").capitalize()
### OLD ###

enum ATTRIBUTES {
	HEALING,
	ENERGY,
	CURE_DISEASE,
	POISON,
}

enum {
	INSTANT,
	OVERTIME,
}

const JSON_PATH: String = "res://resources/potion_list.json"
const PLACEHOLDER: Texture = preload("res://icon.svg")

static var potion_ingredient_index: Dictionary[String, PotionIngredient] = {}:
	get: 
		if potion_ingredient_index.size() <= 0: 
			potion_ingredient_index = _read_json_data()
		return potion_ingredient_index

# finds which of the entries is the highest
static func get_max(_potion_effects: Dictionary[String, float]) -> String:
	var winner := ""
	
	for effect in _potion_effects:
		if winner == "":
			winner = effect
			continue

		if _potion_effects[effect] > _potion_effects[winner]:
			winner = effect
			
	return winner

# totals the values.
# this is static incase we want a way to get a potion's value without having one created
static func get_value(_potion_effects: Dictionary[String, float]) -> float:
	
	var best_effect = get_max(_potion_effects)
	var potion_value = _potion_effects[best_effect]

	for opposing_effect in _potion_effects:
		if opposing_effect == best_effect:
			continue

		potion_value += _potion_effects[best_effect] - _potion_effects[opposing_effect]

	return potion_value

static func _read_json_data() -> Dictionary[String, PotionIngredient]:
	var json_string: String = FileAccess.open(JSON_PATH, FileAccess.READ).get_as_text()
	var json_data: JSON = JSON.new()

	assert(json_data.parse(json_string) == OK, 
			"Variable json_data was null. %s" % [json_data.get_error_message()])

	var potion_data = json_data.data["potions"]
	var temp_potion_ingredient_index: Dictionary[String, PotionIngredient]
	# this should be changed for a more efficent option at some point
	for entry in potion_data:
		var temp_potion: PotionIngredient = PotionIngredient.new()
		temp_potion.name = entry["name"]
		temp_potion.sprite = load(entry["sprite"])

		temp_potion.healing = entry["healing"]
		temp_potion.energy = entry["energy"]
		temp_potion.cure_disease = entry["cure_disease"]
		temp_potion.poison = entry["poison"]

		temp_potion.instant = entry["instant"]
		temp_potion.overtime = entry["overtime"]

		temp_potion_ingredient_index[temp_potion.name] = temp_potion.duplicate()

	return temp_potion_ingredient_index
