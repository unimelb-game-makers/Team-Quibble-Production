class_name AutoFoliage extends Foliage

@export var markers: Array[Marker3D]
@export var ingredient_medallion_scene: PackedScene
var ingredient_sprites: Array[IngredientMedallion]

func _ready() -> void:
	super()

func initialise(ingredient: Alchemy.IngredientID) -> void:
	self.ingredient = ingredient
	populate_markers()
	interactable.interact_popup_text = Alchemy.find_ingredient_by_id(ingredient).ingredient_name

func _on_interact():
	super()
	for sprite in ingredient_sprites:
		sprite.die()
		
## creates a 3dsprite for each ingredient marker and gives it the texture of
## the ingredient in question
func populate_markers() -> void:
	for marker in markers:
		var sprite: IngredientMedallion = ingredient_medallion_scene.instantiate()
		var ingredient: PotionIngredient = Alchemy.find_ingredient_by_id(ingredient)
		sprite.initialise(ingredient.ingredient_sprite)
		marker.add_child(sprite)
		sprite.position = Vector3.ZERO
		sprite.rotation.y = randf()
		ingredient_sprites.append(sprite)
