## A class responsible for generating Foliage 
## objects around the map at a series of spawn points
## the spawn points in question are the children of the node
class_name FoliageManager extends Node

var ingredient_foliage_spawn_points: Array[Marker3D]

##ingredients that this manger spawns. the keys are the ingredients,
## and the values are the weights
@export var ingredients: Dictionary[Alchemy.IngredientID, float]

##the actual object that gets spawned
@export var auto_foliage_scene: PackedScene

## for each marker, the chance that it spawns a foliage
@export var ingredient_foliage_spawn_rate: float


func _ready() -> void:
	for marker in get_children():
		if marker is Marker3D:
			ingredient_foliage_spawn_points.append(marker)
	
	apply_tutorial_ingredients()
	adjust_foliage_weights()

	await get_tree().process_frame
	spawn_foliage()

func adjust_foliage_weights() -> void:
	for item in ForestSceneModifications.weighted_items:
		if ingredients.has(item):
			ingredients[item] *= ForestSceneModifications.weighted_items[item]

	if TutorialDirector.tutorial_day:
		return

	if CustomerManager.customer_queue.is_empty():
		return

	var customer = CustomerManager.customer_queue.front()

	for ingredient_id in ingredients:
		var ingredient = Alchemy.find_ingredient_by_id(ingredient_id)

		for attribute in ingredient.attributes:
			if ingredient.attributes[attribute] <= 0:
				continue

			var need = Alchemy.attribute_to_need_index.get(attribute, -1)

			if need in customer.needs:
				ingredients[ingredient_id] *= 1.75
				break

func spawn_foliage() -> void:
	if ingredients.is_empty():
		return
		
	for marker in ingredient_foliage_spawn_points:
		var does_spawn: bool = randf() <= ingredient_foliage_spawn_rate
		if not does_spawn:
			continue
		
		var ingredient: Alchemy.IngredientID = Utils.pick_random_weighted(ingredients.keys(), ingredients.values())
		var foliage_instance: AutoFoliage = auto_foliage_scene.instantiate()
		foliage_instance.initialise(ingredient)
		marker.add_child(foliage_instance)
		foliage_instance.global_position = Utils.get_marker_ground_pos(marker)

func apply_tutorial_ingredients() -> void:
	if not TutorialDirector.tutorial_day or TimeCycle.days_passed != 2:
		return

	match name:
		"TreeFoliageManager":
			ingredients = {
				Alchemy.IngredientID.INGR_WILLOW_BARK: 1.0
			}

		"CaveFoliageManager":
			ingredients = {
				Alchemy.IngredientID.INGR_SEA_SALT: 1.0
			}

		_:
			ingredients.clear()

	ingredient_foliage_spawn_rate = 1.0
