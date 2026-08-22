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

func _ready() -> void:
	sub_viewport = get_tree().get_first_node_in_group("GameSubViewport")

func change_active_scene_to_packed(scene: PackedScene) -> bool:
	if not scene.can_instantiate() or not sub_viewport:
		return false
		
	var new_scene_node = scene.instantiate()
	
	if sub_viewport.get_child_count(0) == 1:
		sub_viewport.get_child(0).queue_free()
	await get_tree().process_frame
	
	sub_viewport.add_child(new_scene_node)
	return true

func change_active_scene_to_file(path: String) -> bool:
	assert(sub_viewport, "A sub viewport could not be found")
		
	var error = ResourceLoader.load_threaded_request(path)
	
	if error:
		print_debug("error while loading scene resource with code: %s" % error)
		return false
		
	var scene = await wait_for_resource(path)
	
	if not scene or not scene is PackedScene:
		return false
	
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
