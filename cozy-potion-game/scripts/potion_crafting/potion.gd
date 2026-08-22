class_name Potion
extends Resource

enum {
	HEALING,
	ENERGY,
	CURE_DISEASE,
	POISON,
}

enum {
	INSTANT,
	OVERTIME,
}

const JSON_PATH: String = "res://scripts/potion_crafting/potion_list.json"
const PLACEHOLDER: Texture = preload("res://icon.svg")

static var potion_ingredient_index: Dictionary[String, PotionIngredient] = {}:
	get: 
		if potion_ingredient_index.size() <= 0: 
			potion_ingredient_index = _read_json_data()
		return potion_ingredient_index

var name: String = "Inert Potion"
var value: int = 0

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
