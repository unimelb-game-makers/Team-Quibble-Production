extends Control

#the viewport in which the game world and ui is rendered
var sub_viewport: SubViewport:
	get():
		if sub_viewport:
			return sub_viewport
		elif is_inside_tree():
			sub_viewport = get_tree().get_first_node_in_group("GameSubViewport")
			return sub_viewport
		return null

var screen_transition_rect_anim_player: AnimationPlayer:
	get():
		if screen_transition_rect_anim_player:
			return screen_transition_rect_anim_player
		elif is_inside_tree():
			screen_transition_rect_anim_player = get_tree().get_first_node_in_group("SceneTransitionRectAnimPlayer")
			return screen_transition_rect_anim_player
		return null

## concurrency
var loading_scene: bool = false

enum TRANSITIONS{
	NONE,
	FADE,
}

func _ready() -> void:
	sub_viewport = get_tree().get_first_node_in_group("GameSubViewport")
	screen_transition_rect_anim_player = get_tree().get_first_node_in_group("SceneTransitionRectAnimPlayer")


func change_active_scene_to_packed(scene: PackedScene) -> bool:
	if not scene or not scene.can_instantiate() or not sub_viewport or loading_scene:
		return false
	
	loading_scene = true
	var new_scene_node = scene.instantiate()
	
	if sub_viewport.get_child_count(0) == 1:
		sub_viewport.get_child(0).queue_free()
	await get_tree().process_frame
	
	sub_viewport.add_child(new_scene_node)

	await warm_up_scene(new_scene_node)

	loading_scene = false
	return true

func change_active_scene_to_file(path: String, transition_name: TRANSITIONS = TRANSITIONS.NONE) -> bool:
	assert(sub_viewport, "A sub viewport could not be found")
	if loading_scene:
		return false
	
	loading_scene = true
	var error = ResourceLoader.load_threaded_request(path)
	
	if error:
		print_debug("error while loading scene resource with code: %s" % error)
		return false
		
	if transition_name != TRANSITIONS.NONE:
		screen_transition_rect_anim_player.play(TRANSITIONS.find_key(transition_name))
		await screen_transition_rect_anim_player.animation_finished
	
	var scene = await wait_for_resource(path)
	
	if not scene or not scene is PackedScene:
		return false
		
	if transition_name != TRANSITIONS.NONE:
		screen_transition_rect_anim_player.play_backwards(TRANSITIONS.find_key(transition_name))
	
	loading_scene = false
	return await change_active_scene_to_packed(scene)
	
func wait_for_resource(path: String) -> Resource:
	while true:
		var status = ResourceLoader.load_threaded_get_status(path)      
		match status:
			ResourceLoader.THREAD_LOAD_LOADED:
				return ResourceLoader.load_threaded_get(path)
			ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				print_debug("Error loading resource. Error code: ", status)
				return null
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				await get_tree().process_frame
	#seems unneccessary, but godot was angry at me
	return null


func warm_up_scene(scene_root: Node) -> void:
	if not OS.has_feature("web"):
		return

	var original_camera: Camera3D = sub_viewport.get_camera_3d()
	if original_camera == null:
		return

	# Hide rendering behind an opaque loading overlay.
	var overlay := CanvasLayer.new()
	overlay.layer = 100
	scene_root.add_child(overlay)

	var background := ColorRect.new()
	background.color = Color.BLACK
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)
	overlay.add_child(background)

	# Create a temporary camera at the player's viewpoint.
	var warm_camera := Camera3D.new()
	scene_root.add_child(warm_camera)

	warm_camera.global_transform = original_camera.global_transform
	warm_camera.fov = original_camera.fov
	warm_camera.near = original_camera.near
	warm_camera.far = original_camera.far
	warm_camera.cull_mask = original_camera.cull_mask
	warm_camera.environment = original_camera.environment
	warm_camera.attributes = original_camera.attributes

	var starting_rotation := warm_camera.global_rotation

	warm_camera.make_current()

	# Render the environment in eight directions.
	for i in range(8):
		warm_camera.global_rotation = starting_rotation
		warm_camera.rotate_y(deg_to_rad(float(i) * 45.0))

		await RenderingServer.frame_post_draw

	# Restore normal gameplay.
	original_camera.make_current()

	warm_camera.queue_free()
	overlay.free()
