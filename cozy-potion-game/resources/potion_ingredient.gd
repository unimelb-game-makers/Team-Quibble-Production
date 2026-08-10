class_name PotionIngredient
extends Resource

@export var name: String
@export var sprite: Texture

# This is a shit implementation atm and will be changed in the future
@export var healing: float = 0.0 :
	get: return healing 
	set(val): healing = val ; effects["healing"] = val 

@export var energy: float = 0.0 :
	get: return energy 
	set(val): energy = val ; effects["energy"] = val 

@export var cure_disease: float = 0.0 :
	get: return poison 
	set(val): cure_disease = val ; effects["cure_disease"] = val 

@export var poison: float = 0.0 : 
	get: return poison 
	set(val): poison = val ; effects["poison"] = val 

# These prob should be changed to int, float so we can index keys using an enum
var effects: Dictionary[String, float] = {
		"healing": 0.0,
		"energy": 0.0,
		"cure_disease": 0.0,
		"poison": 0.0,
		}


@export var instant: float = 0.0 :
	get: return instant 
	set(val): instant = val ; type["instant"] = val 

@export var overtime: float = 0.0 :
	get: return overtime 
	set(val): overtime = val ; type["overtime"] = val 

var type: Dictionary[String, float] = {
		"instant": 0.0,
		"overtime": 0.0,
}

# Sums all the elements in an array
static func sum(_total: float, _next: float) -> float:
	return _total + _next
