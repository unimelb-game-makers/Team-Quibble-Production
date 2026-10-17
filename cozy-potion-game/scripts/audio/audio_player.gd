class_name AudioPlayer extends AudioStreamPlayer

## This plays audio to the Sfx bus.
func play_audio(audio: AudioStream):
	stream = audio
	play()
