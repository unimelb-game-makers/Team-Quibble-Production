extends MarginContainer

@export var master_volume: HSlider
@export var music_volume: HSlider
@export var sfx_volume: HSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_volume.value_changed.connect(_on_master_volume_changed)
	music_volume.value_changed.connect(_on_music_volume_changed)
	sfx_volume.value_changed.connect(_on_sfx_volume_changed)

	await MusicController.ready

	sync_with_controller()

func sync_with_controller() -> void:
	music_volume.set_value_no_signal(MusicController.music.volume)

func _on_master_volume_changed(value: float) -> void:
	pass

func _on_music_volume_changed(value: float) -> void:
	var volume = (value * (1.0 + master_volume.value /100.0))/100.0
	MusicController.music.volume = volume
	print(volume)

func _on_sfx_volume_changed(value: float) -> void:
	pass
