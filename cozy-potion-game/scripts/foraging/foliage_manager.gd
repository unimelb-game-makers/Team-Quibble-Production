## A class responsible for generating Foliage 
## objects around the map at a series of spawn points
class_name FoliageManager extends Node

@export var ingredient_foliage_spawn_points: Array[Marker3D]

@export var decorative_foliages: Dictionary[PackedScene, float]

@export var ingredient_foliages: Dictionary[PackedScene, float]

@export var ingredient_foliage_spawn_rate: float

@export var forest_root: Node3D

func _ready() -> void:
	await get_tree().process_frame
	spawn_foliage()

func spawn_foliage() -> void:
	for marker in ingredient_foliage_spawn_points:
		var does_spawn: bool = randf() <= ingredient_foliage_spawn_rate
		if not does_spawn:
			continue
		
		var foliage_to_spawn: PackedScene = Utils.pick_random_weighted(\
		ingredient_foliages.keys(), ingredient_foliages.values())
		
		var foliage_instance: Foliage = foliage_to_spawn.instantiate()
		forest_root.add_child(foliage_instance)
		foliage_instance.global_position = marker.global_position
