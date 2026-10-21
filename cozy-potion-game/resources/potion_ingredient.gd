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
				
	# 4. Turn the image back into a usable texture
	var new_texture = ImageTexture.create_from_image(img)
	ingredient_sprite = new_texture
	process_applied.append(id)
	for attribute in process.attribute_changes:
		attributes[attribute] *= process.attribute_changes[attribute]

func get_greatest_attribute() -> Alchemy.AttributeID:
	return attributes.find_key(attributes.values().max())
