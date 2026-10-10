## Node that emits 3D positional audio.
class_name AudioPlayer3D extends AudioStreamPlayer3D

@export var audio_library : AudioLibrary

enum playback_condition { # Defined in UML as playback_type but that already exists
	PLAY_ONESHOT,
	PLAY_LOOP,
	PLAY_LOOP_UNTIL_SIGNAL,
}

func _ready() -> void:
	finished.connect(func(): if !is_playing(): queue_free())
	add_to_group(Utils.Group.GROUP_AUDIO)

func play_file(audio_file: StringName, play_options: playback_condition = playback_condition.PLAY_ONESHOT) -> void:
	stream = audio_library.get_audio(audio_file)
	match play_options:
		playback_condition.PLAY_ONESHOT:
			pass
	
	play()
