class_name PotionIngredient
extends Resource

# Todo: change this to a binary string cus faster probably
var ingredient_name: String = ""
var ingredient_sprite: Texture2D = preload("uid://dexko6nfrs6tc")
# so it will throw an out of bounds error if not set
var ingredient_id: Alchemy.IngredientID
var valid_process_methods: Array[Alchemy.ProcessID] = []

# This will make it so you can index it using the Alchemy.AttributeID
var attributes: Dictionary[Alchemy.AttributeID, int]

# What processes have been applied to thing
var process_applied: Array[Alchemy.ProcessID]
