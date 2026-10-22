class_name MerchantUI extends CanvasLayer

@export var merchant_item_box_scene: PackedScene
@export var item_box_container: VBoxContainer

func _ready() -> void:
	populate_container()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("close_minigame"):
		get_tree().get_first_node_in_group(Utils.Group.GROUP_PLAYER).accepting_control = true
		hide()

func populate_container()-> void:
	for i in range(4):
		var item = Alchemy.ingredient_list.filter(func(x:PotionIngredient): return x.purchaseable).pick_random()
		var box: MerchantItemBox = merchant_item_box_scene.instantiate()
		box.initialise(item)
		item_box_container.add_child(box)
	
