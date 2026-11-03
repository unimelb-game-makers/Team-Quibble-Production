class_name Potion
extends Resource

var potion_name: String = "Inert Potion"
var potion_sprite: Texture2D

const BOTTLE_EMPTY = preload("res://assets/sprites/potions/bottle_empty_64.png")
const BOTTLE_LIQUID = preload("res://assets/sprites/potions/bottle_liquid_64.png")
const BOTTLE_CORK = preload("res://assets/sprites/potions/bottle_cork_64.png")

##sum of ingredient values
var base_gold_value: int
var potion_id: Alchemy.PotionID
var potion_primary: Alchemy.AttributeID
var potion_secondary: Alchemy.AttributeID = -1
var potion_attribute_strength: int

func create_potion_sprite() -> void:
	var liquid_image := BOTTLE_LIQUID.get_image()
	var bottle_image := BOTTLE_EMPTY.get_image()
	var cork_image := BOTTLE_CORK.get_image()

	var liquid_color = Alchemy.potion_referance[potion_id].potion_color

	for x in liquid_image.get_width():
		for y in liquid_image.get_height():
			liquid_image.set_pixel(x, y, Color(liquid_color, liquid_image.get_pixel(x, y).a))

	liquid_image.blend_rect(bottle_image, Rect2i(Vector2i.ZERO, bottle_image.get_size()), Vector2i.ZERO)
	liquid_image.blend_rect(cork_image, Rect2i(Vector2i.ZERO, cork_image.get_size()), Vector2i.ZERO)

	potion_sprite = ImageTexture.create_from_image(liquid_image)

func constructor(_attributes: Dictionary[Alchemy.AttributeID, int], _ingredients: Array[PotionIngredient]) -> void:	
	for ingredient in _ingredients:
		base_gold_value += int(ingredient.ingredient_price)
	
	var keys := _attributes.keys()
	keys.sort_custom(func(a, b): return _attributes[a] > _attributes[b])
	
	#for key in keys:
		#print_debug("%s:%s" % [Alchemy.AttributeID.keys()[key], _attributes[key]])
		
	potion_id = keys[0]
	potion_primary = keys[0]
	create_potion_sprite()
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

	if _ingredients.size() < 2:
		return

	if keys.size() < 2:
		return

	var primary_strength: int = _attributes[keys[0]]
	var secondary_strength: int = _attributes[keys[1]]

	if secondary_strength < 20:
		return

	if secondary_strength < primary_strength * 0.6:
		return

	potion_secondary = keys[1]
	potion_name += " and " + Alchemy.AttributeID.keys()[potion_secondary].trim_prefix("ATTR_").capitalize()
