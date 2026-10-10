class_name AudioManager extends AudioStreamPlayer

## One source of audio for minigames

func _ready() -> void:
	Utils.audio_manager = self

func play_audio(audio: AudioStream):
	stream = audio
	play()
