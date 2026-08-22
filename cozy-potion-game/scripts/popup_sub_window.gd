extends CanvasLayer

@export var sub_viewport: SubViewport
@export var animation_player : AnimationPlayer

# Don't do this. Never assume a node will be there. I'm already not the biggest fan of using the
# whole `@onready var = $Node` method but given the time constraints I'm fine if it's used for
# children but not for getting nodes up the tree. Scripts should serve a single purpose and be as
# lazy with aquiring the information they need.
#@onready var player: WorldPlayer = $"../Node3D/Player" 

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
		print("connected to node %s" % object)

func start_display_popup(_scene_to_load: PackedScene) -> void:
	player.accepting_control = false
	popup = _scene_to_load.instantiate()

	popup.minigame_won.connect(end_display_popup)

	sub_viewport.add_child(popup)
	animation_player.play(&"fade_in")

func end_display_popup() -> void:
	animation_player.play(&"fade_out")
	await animation_player.animation_finished
	sub_viewport.remove_child(popup)
	popup.minigame_won.disconnect(end_display_popup)

	popup.queue_free()
	
	player.accepting_control = true

## this was connected in-editor.
## TODO: set mechanically for all interactables in scene. this could be done by giving the 
## interactable a group
## func _on_interactable_object_interacted(_scene_to_load: PackedScene) -> void:
##	start_display_popup(_scene_to_load.instantiate())
