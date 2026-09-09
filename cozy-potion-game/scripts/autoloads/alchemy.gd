extends Node
# This singleton will most likely be gutted at some point in favor of having its functionality spread out so
# it isn't handling everything related to potion making

# TODO: Have an external script that will convert all ID tags from the spread sheet into consts

enum AttributeID {
	ATTR_HEALING,
	ATTR_MANA,
	ATTR_PARALYSIS,
	ATTR_FOCUS,
	ATTR_STRENGTH,
	ATTR_PERCEPTION,
	ATTR_ENDURANCE,
	ATTR_CHARISMA,
	ATTR_INTELLIGENCE,
	ATTR_AGILITY,
	ATTR_LUCK,
	ATTR_FLAME,
	ATTR_FROST,
	ATTR_SHOCK,
	ATTR_WIND,
	ATTR_EARTH,
	ATTR_WATER,
	ATTR_PURIFICATION,
	ATTR_ANTIDOTE,
	ATTR_SLEEP,
	ATTR_CALMING,
	ATTR_LIGHT,
	ATTR_DARK,
	ATTR_PAIN_RELIEF,
}

enum IngredientID{
	INGR_APPLE,
	INGR_GINGER,
	INGR_LEMON,
	INGR_CHAMOMILE,
	INGR_PEPPERMINT,
	INGR_GARLIC,
	INGR_HONEY,
	INGR_COFFEE_BEAN,
	INGR_GINSENG,
	INGR_LAVENDER,
	INGR_SAGE,
	INGR_ROSEMARY,
	INGR_CINNAMON,
	INGR_CHILI,
	INGR_SEA_SALT,
	INGR_CLOVER,
	INGR_WILLOW_BARK,
	INGR_POPPY_RESIN,
	INGR_MOONCAP,
	INGR_EMBERROOT,
	INGR_FROSTMINT,
	INGR_SPARK_THISTLE,
	INGR_WHISPER_REED,
	INGR_IRONMOSS,
	INGR_DEEPWATER_KELP,
	INGR_SILVERLEAF,
	INGR_SHADEBERRY,
	INGR_SCHOLARS_MOREL,
	INGR_NIMBLEFERN,
	INGR_VELVET_ROSE,
	INGR_STONECAP,
	INGR_BASILISK_SCALE,
	INGR_SPIDER_LILY,
	INGR_SIREN_PEARL,
	INGR_PHOENIX_ASH,
	INGR_ICE_WYRM_SCALE,
	INGR_STORMGLASS_DUST,
	INGR_SAINTS_BALM,
	INGR_DREAM_ORCHID,
	INGR_VOID_TRUFFLE,
}

enum PotionID {
	POT_HEALING,
	POT_MANA,
	POT_PARALYSIS,
	POT_FOCUS,
	POT_STRENGTH,
	POT_PERCEPTION,
	POT_ENDURANCE,
	POT_CHARISMA,
	POT_INTELLIGENCE,
	POT_AGILITY,
	POT_LUCK,
	POT_FLAME,
	POT_FROST,
	POT_SHOCK,
	POT_WIND,
	POT_EARTH,
	POT_WATER,
	POT_PURIFICATION,
	POT_ANTIDOTE,
	POT_SLEEP,
	POT_CALMING,
	POT_LIGHT,
	POT_DARK,
	POT_PAIN_RELIEF,
}

enum ProcessID {
	PROC_CHOP,
	PROC_GRIND,
	PROC_PRESS,
	PROC_BOIL,
	PROC_DRY,
	PROC_FREEZE,
	PROC_FRY,
	PROC_DISTILL,
} 

const INGREDIENT_JSON: String = "res://resources/json/ingredients.json"
const PROCESSES_JSON: String = "res://resources/json/processes.json"
const POTION_JSON: String = "res://resources/json/potion_list.json"

var ingredient_list: Array[PotionIngredient] = []
var potion_referance: Array[PotionReference] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	read_ingredient_data()
	read_potion_data()
	# brew_potion([ingredient_list[IngredientID.INGR_APPLE], 
	# 			ingredient_list[IngredientID.INGR_GINSENG], 
	# 			ingredient_list[IngredientID.INGR_HONEY]])

# This should only run once
func read_ingredient_data() -> void:
	var json_data: JSON = Utils.get_json(INGREDIENT_JSON)

	ingredient_list.resize(IngredientID.size())
	var index := 0

	for ingredient in json_data.data:
		var temp_ingredient := PotionIngredient.new()
		temp_ingredient.ingredient_name = ingredient["Ingredient Name"]

		# Used to index an enum with a string
		temp_ingredient.ingredient_id = IngredientID.keys().find(ingredient["Ingredient ID"]) as IngredientID
		
		for process in ingredient["Compatible Process IDs"].split(", "):
			temp_ingredient.valid_process_methods.append(ProcessID.keys().find(process))

		for attribute in AttributeID.values():
			temp_ingredient.attributes.set(attribute, ingredient[AttributeID.keys()[attribute]])

		ingredient_list[index] = temp_ingredient
		index += 1

func read_potion_data() -> void:
	var json_data: JSON = Utils.get_json(POTION_JSON)

	potion_referance.resize(PotionID.size())

	for potion in json_data.data:
		var temp_potion := PotionReference.new()

		# There's prob a better way to do this lol
		temp_potion.potion_id = PotionID.keys().find(potion["POT_ID"]) as PotionID
		temp_potion.potion_name = potion["POT_NAME"]
		temp_potion.potion_color = Color(potion["COLOUR_HEX"])
		temp_potion.potion_attribute = AttributeID.keys().find(potion["ATTR_ID"]) as AttributeID
		temp_potion.potion_attribute_name = potion["PRIMARY_ATTRIBUTE"]
		temp_potion.potion_need_id = potion["NEED_ID"]

		potion_referance[temp_potion.potion_id] = temp_potion

func brew_potion(_ingredient_list: Array[PotionIngredient]) -> Potion:
	var _attributes := sum_attributes(_ingredient_list)
	
	var potion := Potion.new()
	potion.constructor(_attributes)
	
	return potion	

func sum_attributes(_ingredient_list: Array[PotionIngredient]) -> Dictionary[Alchemy.AttributeID, int]:
	var _attributes: Dictionary[Alchemy.AttributeID, int]
	_attributes.assign(_ingredient_list[0].attributes.duplicate())
	if _ingredient_list.size() == 1:
			return _attributes
	
	for ingredient in range(1, _ingredient_list.size()-1):
		for attribute in AttributeID.values():
			var new_value = _attributes[attribute] + _ingredient_list[ingredient].attributes[attribute]
			_attributes[attribute] = new_value
			
	return _attributes
