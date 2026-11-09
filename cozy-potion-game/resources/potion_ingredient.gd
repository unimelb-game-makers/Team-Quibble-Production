class_name PotionIngredient
extends Resource

# Todo: change this to a binary string cus faster probably
var ingredient_name: String
var ingredient_sprite: Texture2D
var ingredient_price: float = 50
var ingredient_color: Color
var purchaseable: bool
# so it will throw an out of bounds error if not set
var ingredient_id: Alchemy.IngredientID
var valid_process_methods: Array[Alchemy.ProcessID]

# This will make it so you can index it using the Alchemy.AttributeID
var attributes: Dictionary[Alchemy.AttributeID, int]

# What processes have been applied to thing
var process_applied: Array[Alchemy.ProcessID]

const DECOCTION_LINE = preload("res://assets/sprites/minigame/boiling_minigame/decoction_line_128.png")

func apply_process(id: Alchemy.ProcessID) -> void:
	if process_applied.size() > 0:
		return
		
	var process: Process = Alchemy.find_process_by_id(id)
		# 1. Get the image data from the texture
	var img: Image = process.texture.get_image()

	# 3. Loop through the pixels and change colors
	for x in range(img.get_width()):
		for y in range(img.get_height()):
			var current_color = img.get_pixel(x, y)
			if current_color.a > 0: # If pixel isn't transparent
				img.set_pixel(x, y, current_color * ingredient_color) # Change to yellow
				
	if id == Alchemy.ProcessID.PROC_BOIL:
		var line_image = DECOCTION_LINE.get_image()
		img.blend_rect(
			line_image,
			Rect2i(Vector2i.ZERO, line_image.get_size()),
			Vector2i.ZERO
		)
	
	# 4. Turn the image back into a usable texture
	var new_texture = ImageTexture.create_from_image(img)
	ingredient_sprite = new_texture
	process_applied.append(id)
	for attribute in process.attribute_changes:
		attributes[attribute] *= int(process.attribute_changes[attribute])

func get_greatest_attribute() -> Alchemy.AttributeID:
	return attributes.find_key(attributes.values().max())
# copy ingredient into player inventory to avoid processing remaining ingredients in drawer
func copy() -> PotionIngredient:
	var ingredient = PotionIngredient.new()
	ingredient.ingredient_name = ingredient_name
	ingredient.ingredient_id = ingredient_id
	ingredient.ingredient_sprite = ingredient_sprite
	ingredient.ingredient_price = ingredient_price
	ingredient.ingredient_color = ingredient_color
	ingredient.purchaseable = purchaseable
	ingredient.valid_process_methods = valid_process_methods.duplicate()
	ingredient.attributes = attributes.duplicate()
	ingredient.process_applied = process_applied.duplicate()
	return ingredient
