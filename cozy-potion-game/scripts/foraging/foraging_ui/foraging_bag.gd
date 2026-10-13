class_name ForagingBag extends CanvasLayer


@export var player: WorldPlayer
@export var bag_button: TextureButton
@export var bag_display: Control
@export var blur_rect: ColorRect
@export var hover_inventory: HoverInventory

func _ready() -> void:
	if not player:
		var player = get_tree().get_first_node_in_group(Utils.Group.GROUP_PLAYER)
		
	bag_button.pressed.connect(_on_bag_button_pressed)
	
	bag_display.visible = false
	blur_rect.visible = false

func _on_bag_button_pressed() -> void:
	bag_display.visible = not bag_display.visible
	player.accepting_control = not bag_display.visible
	blur_rect.visible = bag_display.visible

func add_stacks_to_pantry() -> void:
	var stacks: Array[Stack] = hover_inventory.inventory.export_stacks()
	PersistentInventory.pantry.append_array(stacks)

func _exit_tree() -> void:
	add_stacks_to_pantry()
