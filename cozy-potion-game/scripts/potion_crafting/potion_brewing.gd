class_name PotionBrewing
extends Node

func attempt_brewing(_potion_recipe: Array[PotionIngredient]) -> Potion:
	# Unless something else broke, this method shouldn't get a recipe bigger than 3 ingredients
	assert(_potion_recipe.size() <= 3 and _potion_recipe.size() > 0,
			"Attempted to brew a potion with more than 3 ingredients")

	# this could probably be moved to the potion.gd constructor
	var index := 1
	var potion := Potion.new()

	# things kept unintendedly changing the resources. access modifers would sure be nice.
	var effect_score := _potion_recipe[0].effects.duplicate()
	var type_score := _potion_recipe[0].type.duplicate()
	
	var effect_sum: float = effect_score.values().reduce(PotionIngredient.sum, 0)

	# modify the scores based on the other ingredients
	while true:
		if _potion_recipe.size() <= index:
			break

		for effect_name in _potion_recipe[index].effects.keys():
			effect_score[effect_name] *= 1 + _potion_recipe[index].effects[effect_name] / effect_sum

		for type_name in _potion_recipe[index].type.keys():
			type_score[type_name] += _potion_recipe[index].type[type_name]
		
		index += 1

	# get the strongest from each
	var potion_effect: String = Potion.get_max(effect_score)
	var potion_type: String = Potion.get_max(type_score)

	potion.name = "Potion of %s %s" % [potion_type, potion_effect]
	potion.value = Potion.get_value(effect_score) + type_score[potion_type]

	return potion
	
