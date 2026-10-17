class_name IngredientMedallion extends Node3D

@export var sprites: Array[Sprite3D]
func initialise(ingredient_sprite: Texture2D) -> void:
	for sprite in sprites:
		sprite.texture = ingredient_sprite

func die() -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", Vector3(0.0,0.3,0.0), 0.1)
	tween.tween_property(self, "position", Vector3(0.0,0.1,0.0), 0.2)
	tween.tween_callback(queue_free)
