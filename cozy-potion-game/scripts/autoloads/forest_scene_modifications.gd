##This autoload doesn't actually do anything itself, it just stores values
## that other classes like FoliageManager will use.

## it is recommended that you clear the modifications after the tutorial is done
extends Node

##self-explanatory. Vector3.zero will be ignored
var spawn_location: Vector3

##keys are items you want to weight, their weights will be
## multiplied by the value
var weighted_items: Dictionary[Alchemy.IngredientID, float]

func weight_item(item: Alchemy.IngredientID, weight: float) -> void:
	weighted_items[item] = weight


func clear_modifications() -> void:
	weighted_items.clear()
	spawn_location = Vector3.ZERO
