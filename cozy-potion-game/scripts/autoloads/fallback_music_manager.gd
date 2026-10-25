extends Node

@export var music_player: AudioStreamPlayer

@export var track_dict: Dictionary[TRACKS, AudioStream]

const FADE_OUT_TIME = 3
const FADE_IN_TIME = 5

enum TRACKS{
	MAIN_MENU,
	SHOP_DAY,
	SHOP_NIGHT,
	FOREST_DAY,
	FOREST_NIGHT,
}

enum FADE{
	NONE,
	OUT,
	IN,
	BOTH,
}

func play_music_track(track_id: TRACKS, fade: FADE = FADE.NONE) -> void:
	if not track_dict.has(track_id) or music_player.stream == track_dict[track_id]:
		return
	
	var old_music_player = music_player
	music_player = music_player.duplicate()
	add_child(music_player)

	music_player.stream = track_dict[track_id]
	music_player.play()
	music_player.volume_linear = 1
	
	if fade & 1:
		var tween = create_tween()
		tween.tween_property(old_music_player, "volume_linear", 0, FADE_OUT_TIME)
		tween.tween_callback(old_music_player.queue_free)
	else:
		old_music_player.queue_free()
	
	if fade & (1 << 1):
		music_player.volume_linear = 0
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property(music_player, "volume_linear", 1, FADE_IN_TIME)
		await get_tree().create_timer(FADE_IN_TIME).timeout

func fade_current_volume_to(volume: float, time: float) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(music_player, "volume_linear", volume, time)
