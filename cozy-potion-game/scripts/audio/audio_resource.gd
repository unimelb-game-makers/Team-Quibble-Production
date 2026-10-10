## Array of AudioStreams. Godot doesn't support nested typing yet.
class_name AudioResource extends Resource

@export var resource_array : Array[AudioStream]

func get_random() -> AudioStream:
	return resource_array.pick_random()
