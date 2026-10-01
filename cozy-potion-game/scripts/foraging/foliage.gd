class_name Foliage extends Node3D

@export var interactable: Interactable
@export var ingredient: Alchemy.IngredientID
@export var model: Node3D

var foraging_bag: ForagingBag

func _ready() -> void:
	#if not (ingredient and interactable):
		#print_debug(1)
		#interactable.queue_free()
	
	foraging_bag = get_tree().get_first_node_in_group(Utils.Group.GROUP_FORAGING_BAG)
	if not foraging_bag:
		interactable.queue_free()
	
	interactable.interacted.connect(_on_interact)

func _on_interact():
	var item_stack = Stack.new(1, Alchemy.ingredient_list[ingredient])
	foraging_bag.hover_inventory.inventory.blind_add_stack(item_stack)
	
	interactable.queue_free()
	
	if model and model.material:
		model.material.albedo_color -= Color(.5,.5,.5)
		
