class_name PopupSubWindow
extends CanvasLayer

@export var sub_viewport: SubViewport
@export var animation_player : AnimationPlayer
@export var black_rect: ColorRect

var player: WorldPlayer
var popup: Node

func _ready() -> void:
	visible = false
	# This may seem overkill but trust the process. You can't miss spell a const
	var ineteractable_objects = get_tree().get_nodes_in_group(Utils.Group.GROUP_INTERACTABLE_OBJECTS)

	# This also sucks but a more modular method will be made in the future. This way we don't have to
	# go looking for the player.
	player = get_tree().get_first_node_in_group(Utils.Group.GROUP_PLAYER)

	assert(player, "Could not find player. Something is wrong")

	if ineteractable_objects.size() <= 0:
		push_warning("Current Scene has no interactable objects. This may be an issue")
		return
	
	for object in ineteractable_objects:
		assert(object is InteractableArea, 
				"A node that isn't an interactable object has been assigned said tag")
		object.connect("interacted", start_display_popup)
		print_debug("connected to node %s" % object)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_minigame"):
		if popup: end_display_popup(null)

func start_display_popup(_scene_to_load: PackedScene, hotbar: Inventory,\
		input_index: int) -> void:
	player.accepting_control = false
	popup = _scene_to_load.instantiate()

	popup.minigame_won.connect(end_display_popup, ConnectFlags.CONNECT_ONE_SHOT)

	sub_viewport.add_child(popup)
	animation_player.play(&"fade_in")
	
	# Assuming this is a minigame
	if popup is Minigame:
		popup.set_hotbar(hotbar, input_index)

func end_display_popup(output_hotbar: Inventory) -> void:
	if output_hotbar != null:
		player.hotbar.assign_new_inventory(output_hotbar)
	
	animation_player.play_backwards(&"fade_in")
	await animation_player.animation_finished
	# Raise errors but idk what they do
	sub_viewport.remove_child(popup)
	popup.minigame_won.disconnect(end_display_popup)

	popup.queue_free()
	
	player.accepting_control = true
