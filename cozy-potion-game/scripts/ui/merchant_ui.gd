class_name MerchantUI extends CanvasLayer

@export var merchant_item_box_scene: PackedScene
@export var item_box_container: VBoxContainer

func _ready() -> void:
	populate_container()

func populate_container()-> void:
	var item: PotionIngredient = Alchemy.ingredient_list.front()
	for i in range(4):
		var box: MerchantItemBox = merchant_item_box_scene.instantiate()
		box.initialise(item)
		item_box_container.add_child(box)
