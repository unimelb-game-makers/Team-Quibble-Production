class_name Portal extends Node3D

@export var destination_path: StringName
@export var interactable: Interactable
@export var player_spawn_position: Marker3D

@export var enter_portal_sounds: AudioResource

# TODO: I don't know where these would play
@export var portal_spawn_sounds: AudioResource
@export var portal_despawn_sounds: AudioResource

var portal_popup: PortalPopup


static var spawn_at_portal: bool = false

func _ready() -> void:
	interactable.interacted.connect(_on_interact)
	portal_popup = get_tree().get_first_node_in_group("portal_popup")
	if portal_popup:
		portal_popup.no_clicked.connect(cancel_popup)
		portal_popup.yes_clicked.connect(teleport)

func _on_interact() -> void:
	if not spawn_at_portal:
		teleport()
	else:
		portal_popup.show()
		get_tree().get_first_node_in_group("player").accepting_control = false

func cancel_popup() -> void:
	get_tree().get_first_node_in_group("player").accepting_control = true
	portal_popup.hide()

func teleport() -> void:
	spawn_at_portal = true
	SceneManager.change_active_scene_to_file(destination_path, SceneManager.TRANSITIONS.FADE)
	AudioManager.play_audio(enter_portal_sounds.get_random())
	CustomerManager.returning_from_forest = true
