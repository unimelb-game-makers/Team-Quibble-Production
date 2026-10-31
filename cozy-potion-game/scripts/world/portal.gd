class_name Portal extends Node3D

@export var destination_path: StringName
@export var interactable: Interactable
@export var player_spawn_position: Marker3D

@export var enter_portal_sounds: AudioResource
@export var portal_marker: Marker3D

# TODO: I don't know where these would play
@export var portal_spawn_sounds: AudioResource
@export var portal_despawn_sounds: AudioResource

var portal_popup: PortalPopup


static var spawn_at_portal: bool = false
#this is a bit of a hack. Actually, everything i've written
#this week has been a hack. Sorry, reviewer.
var underground: bool = false

func _ready() -> void:
	if portal_marker:
		position = portal_marker.position
	if !TutorialDirector.portal_open:
		position += Vector3(0,-100,0)
		underground = true

	elif TimeCycle.visited_forest_this_day:
		position += Vector3(0,-100,0)
		underground = true
	
	force_update_transform()

	interactable.interacted.connect(_on_interact)
	portal_popup = get_tree().get_first_node_in_group("portal_popup")
	if portal_popup:
		portal_popup.no_clicked.connect(cancel_popup)
		portal_popup.yes_clicked.connect(teleport)

	TimeCycle.day_started.connect(return_from_underground)
	TimeCycle.tutorial_day_started.connect(return_from_underground)

func _on_interact() -> void:
	if not portal_popup:
		teleport()
	else:
		TimeCycle.visited_forest_this_day = true
		portal_popup.show()
		get_tree().get_first_node_in_group("player").accepting_control = false

func return_from_underground() -> void:
	if underground:
		underground = false
		position += Vector3(0,100,0)
		animate_spawn()
		force_update_transform()

func animate_spawn() -> void:
	var tween = get_tree().create_tween()
	scale = Vector3.ONE * 0.1
	tween.tween_property(self, "scale", Vector3.ONE, 0.2)
	
func cancel_popup() -> void:
	get_tree().get_first_node_in_group("player").accepting_control = true
	portal_popup.hide()

func teleport() -> void:
	spawn_at_portal = true
	SceneManager.change_active_scene_to_file(destination_path, SceneManager.TRANSITIONS.FADE)
	AudioManager.play_audio(enter_portal_sounds.get_random())
	CustomerManager.returning_from_forest = true
