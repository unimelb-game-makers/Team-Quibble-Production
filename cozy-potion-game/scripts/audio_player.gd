class_name AudioPlayerUI
extends AudioStreamPlayer

@export var audio_library: AudioLibrary

func play_file(audio_file: StringName) -> void:
	stream = audio_library.get_audio(audio_file)
	play()
