## A class responsible for generating Foliage 
## objects around the map at a series of spawn points
class_name FoliageManager extends Node

var ingredient_foliage_spawn_points: Array[Marker3D]

@export var ingredient_foliage_marker_parent: Node

@export var decorative_foliages: Dictionary[PackedScene, float]

@export var ingredients: Array[Alchemy.IngredientID]

@export var auto_foliage_scene: PackedScene

@export var ingredient_foliage_spawn_rate: float

@export var forest_root: Node3D

func _ready() -> void:
	for marker in ingredient_foliage_marker_parent.get_children():
		ingredient_foliage_spawn_points.append(marker)

	await get_tree().process_frame
	spawn_foliage()
	

func spawn_foliage() -> void:
	for marker in ingredient_foliage_spawn_points:
		var does_spawn: bool = randf() <= ingredient_foliage_spawn_rate
		if not does_spawn:
			continue
		
		var ingredient: Alchemy.IngredientID = ingredients.pick_random()
		var foliage_instance: AutoFoliage = auto_foliage_scene.instantiate()
		foliage_instance.initialise(ingredient)
		forest_root.add_child(foliage_instance)
		foliage_instance.global_position = Utils.get_marker_ground_pos(marker)
