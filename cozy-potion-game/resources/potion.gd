class_name Potion
extends Resource

var potion_name: String = "Inert Potion"
var potion_value: int = 0

var potion_id: Alchemy.PotionID
var potion_primary: Alchemy.AttributeID
var potion_secondary: Alchemy.AttributeID
var potion_attribute_strength: int

func constructor(_attributes: Dictionary[Alchemy.AttributeID, int]) -> void:
	var keys := _attributes.keys()
	keys.sort_custom(func(a, b): return _attributes[a] > _attributes[b])
	
	for key in keys:
		print("%s:%s" % [Alchemy.AttributeID.keys()[key], _attributes[key]])
		
	potion_id = keys[0]
	potion_primary = keys[0]
	potion_attribute_strength = _attributes[keys[0]]
	potion_name = "Potion of "

	match true:
		true when potion_attribute_strength < 20: 
			potion_name += "Trace "
		true when potion_attribute_strength < 40: 
			potion_name += "Lesser "
		true when potion_attribute_strength < 60: 
			potion_name += ""
		true when potion_attribute_strength < 80: 
			potion_name += "Greater "
		true when potion_attribute_strength < 100: 
			potion_name += "Supreme "

	potion_name += Alchemy.AttributeID.keys()[potion_primary].trim_prefix("ATTR_").capitalize()

	if _attributes[keys[0]] != _attributes[keys[1]]:
		return

	potion_secondary = keys[1]
	potion_name += " and " + Alchemy.AttributeID.keys()[potion_secondary].trim_prefix("ATTR_").capitalize()
