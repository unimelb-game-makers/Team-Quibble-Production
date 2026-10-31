class_name SoundMenu extends MarginContainer

@export var master_volume: HSlider
@export var music_volume: HSlider
@export var sfx_volume: HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_volume.value_changed.connect(_on_master_volume_changed)
	music_volume.value_changed.connect(_on_music_volume_changed)
	sfx_volume.value_changed.connect(_on_sfx_volume_changed)
	
	update_sliders()

func update_sliders() -> void:
	master_volume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(&"Master"))
	music_volume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(&"Music"))
	sfx_volume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index(&"Sfx"))


func get_volume(value: float) -> float:
	var master = clamp(master_volume.value, 0.0, 100.0) / 100.0
	var channel = clamp(value, 0.0, 100.0) / 100.0
	return clamp(channel * master, 0.0, 1.0)
	
func _on_master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(&"Master"), value)

func _on_music_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(&"Music"), value)
	#var volume = (value * (1.0 + master_volume.value /100.0))/100.0
	#MusicController.music.volume = volume
	#print(volume)

func _on_ambience_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(&"Ambience"), value)

func _on_sfx_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(&"Sfx"), value)

# func _on_master_volume_changed(value: float) -> void:
# 	# change both music and sfx volumes
# 	MusicController.music.volume = get_volume(music_volume.value)
# 	AudioManager.set_volume(get_volume(sfx_volume.value))

# func _on_music_volume_changed(value: float) -> void:
# 	MusicController.music.volume = get_volume(value)

# func _on_sfx_volume_changed(value: float) -> void:
# 	AudioManager.set_volume(get_volume(value))
