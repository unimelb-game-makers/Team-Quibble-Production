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
	
	adjust_foliage_weights()

	await get_tree().process_frame
	spawn_foliage()

func adjust_foliage_weights() -> void:
	for item in ForestSceneModifications.weighted_items:
		if ingredients.has(item):
			ingredients[item] *= ForestSceneModifications.weighted_items[item]

func filter_ingredients_by_needed() -> void:
	## sets the weight of ingredients that do not contain a needed attribute
	for ingredient in ingredients:
		var ing_res: PotionIngredient = Alchemy.find_ingredient_by_id(ingredient)
	
func spawn_foliage() -> void:
	for marker in ingredient_foliage_spawn_points:
		var does_spawn: bool = randf() <= ingredient_foliage_spawn_rate
		if not does_spawn:
			continue
		
		var ingredient: Alchemy.IngredientID = Utils.pick_random_weighted(ingredients.keys(), ingredients.values())
		var foliage_instance: AutoFoliage = auto_foliage_scene.instantiate()
		foliage_instance.initialise(ingredient)
		marker.add_child(foliage_instance)
		foliage_instance.global_position = Utils.get_marker_ground_pos(marker)
