class_name ForagingBag extends CanvasLayer


@export var player: WorldPlayer
@export var bag_button: TextureButton
@export var bag_display: Control
@export var hover_inventory: HoverInventory

func _ready() -> void:
	if not player:
		var player = get_tree().get_first_node_in_group(Utils.Group.GROUP_PLAYER)
		
	bag_button.pressed.connect(_on_bag_button_pressed)
	
	bag_display.visible = false

func _on_bag_button_pressed():
	bag_display.visible = not bag_display.visible
	player.accepting_control = not player.accepting_control
