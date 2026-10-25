class_name Radio extends Control

@export var prev_button: TextureButton
@export var pause_toggle_button: TextureButton
@export var next_button: TextureButton
@export var replay_button: TextureButton
@export var track_label: Label

@export var pause_button_texture: Texture2D
@export var play_button_texture: Texture2D

func _ready() -> void:
	prev_button.pressed.connect(FallbackMusicManager.play_next_track.bind(-1))
	next_button.pressed.connect(FallbackMusicManager.play_next_track.bind(1))
	pause_toggle_button.pressed.connect(paused_pressed)
	replay_button.pressed.connect(replay_pressed)
	
	FallbackMusicManager.track_changed.connect(update_track_name)
	update_track_name()
	

func update_track_name() -> void:
	track_label.text = FallbackMusicManager.get_current_track_name()
	
func replay_pressed() -> void:
	FallbackMusicManager.toggle_repeat_current_track()
	if FallbackMusicManager.locked:
		replay_button.modulate = Color(0.282, 0.282, 0.282, 0.729)
	else:
		replay_button.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
func paused_pressed() -> void:
	if not FallbackMusicManager.is_paused():
		pause_toggle_button.texture_normal = play_button_texture
		pause_toggle_button.texture_hover = play_button_texture
		pause_toggle_button.texture_focused = play_button_texture
		pause_toggle_button.texture_pressed = play_button_texture
		FallbackMusicManager.toggle_pause()
	else:
		pause_toggle_button.texture_normal = pause_button_texture
		pause_toggle_button.texture_hover = pause_button_texture
		pause_toggle_button.texture_focused = pause_button_texture
		pause_toggle_button.texture_pressed = pause_button_texture
		FallbackMusicManager.toggle_pause()
