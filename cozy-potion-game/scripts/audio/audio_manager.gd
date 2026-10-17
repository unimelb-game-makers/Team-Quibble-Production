class_name AudioManager extends AudioStreamPlayer
## One source of audio for minigames

@onready var ambiencePlayer := AudioStreamPlayer.new()

func _ready() -> void:
	bus = &"Sfx"
	ambiencePlayer.bus = &"Ambience"
	Utils.audio_manager = self
	add_child(ambiencePlayer)

## This plays audio to the Sfx bus.
func play_audio(audio: AudioStream):
	stream = audio
	play()

func play_ambience(ambience: AudioStream):
	ambiencePlayer.stream = ambience
	ambiencePlayer.play()

func stop_ambience():
	ambiencePlayer.stop()
