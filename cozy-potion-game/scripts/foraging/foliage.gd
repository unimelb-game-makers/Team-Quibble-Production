class_name Foliage extends Node3D

@export var interactable: Interactable
@export var ingredient: Alchemy.IngredientID

func _ready() -> void:
	if not ingredient and interactable:
		interactable.queue_free()

func _on_interact():
	pass
