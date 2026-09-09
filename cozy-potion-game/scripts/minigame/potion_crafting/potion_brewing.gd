class_name PotionBrewing
extends Node

static var recipe: Array[PotionIngredient]

func attempt_brewing(_potion_recipe: Array[PotionIngredient]) -> Potion:
	# Unless something else broke, this method shouldn't get a recipe bigger than 3 ingredients
	assert(_potion_recipe.size() <= 3 and _potion_recipe.size() > 0,
			"Attempted to brew a potion with more than 3 ingredients")

	return Alchemy.brew_potion(_potion_recipe)
	
