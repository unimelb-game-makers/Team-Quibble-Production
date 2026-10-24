extends MarginContainer

@export var master_volume: HSlider
@export var music_volume: HSlider
@export var sfx_volume: HSlider

## Its a bad idea to connect anything to value-changed because it
## runs every frame. Every ~0.1 seconds is probably better
@export var slider_poll_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slider_poll_timer.timeout.connect(update_bus_volumes)

func update_bus_volumes() -> void:
	## yeah, yeah, bad magic strings. We're shipping this.
	var music_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(music_index,music_volume.ratio)
	print_debug(AudioServer.get_bus_volume_linear(music_index))
	var sfx_index = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_volume_linear(sfx_index, sfx_volume.ratio)
	var master_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(master_index, master_volume.ratio)
