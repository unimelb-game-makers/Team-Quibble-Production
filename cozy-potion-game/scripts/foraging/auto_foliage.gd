class_name AutoFoliage extends Foliage

@export var markers: Array[Marker3D]
var ingredient_sprites: Array[Sprite3D]

func _ready() -> void:
	super()

func initialise(ingredient: Alchemy.IngredientID) -> void:
	self.ingredient = ingredient
	populate_markers()

func _on_interact():
	super()
	for sprite in ingredient_sprites:
		sprite.queue_free()
		
## creates a 3dsprite for each ingredient marker and gives it the texture of
## the ingredient in question
func populate_markers() -> void:
	for marker in markers:
		var sprite = Sprite3D.new()
		var ingredient: PotionIngredient = Alchemy.ingredient_list[ingredient]
		sprite.texture = ingredient.ingredient_sprite
		marker.add_child(sprite)
		sprite.scale = Vector3.ONE * 0.35
		sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		sprite.position = Vector3.ZERO
		ingredient_sprites.append(sprite)
