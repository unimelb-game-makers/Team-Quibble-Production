class_name AudioLibrary extends Resource

@export var library : Dictionary[StringName, AudioResource]

func get_value(key: StringName) -> AudioResource:
	var value : AudioResource = library.get(key)
	assert(value, "No such key for AudioLibrary exists")
	return value

func get_audio(key: StringName) -> AudioStream:
	# Defaults to getting a random one.
	return get_value(key).get_random()
