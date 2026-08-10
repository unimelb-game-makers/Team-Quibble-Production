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
