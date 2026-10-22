extends AudioStreamPlayer
## One source of audio for minigames

@onready var ambiencePlayer := AudioStreamPlayer.new()

func _ready() -> void:
	bus = &"Sfx"
	ambiencePlayer.bus = &"Ambience"
	add_child(ambiencePlayer)

## This plays audio to the Sfx bus.
func play_audio(audio: AudioStream):
	stream = audio
	play()

# input value from 0.0 to 1.0
func set_volume(value: float):
	volume_linear = value

func play_ambience(ambience: AudioStream):
	ambiencePlayer.stream = ambience
	ambiencePlayer.play()

func stop_ambience():
	ambiencePlayer.stop()
