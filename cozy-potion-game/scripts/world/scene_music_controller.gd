## a class that exists to call the music player when 
## the scene it's in loads and change the music when the time changes
class_name SceneMusicController extends Node

const MUSIC_CHANGE_PROGRESS = 0.5

@export var day_track: FallbackMusicManager.TRACKS
@export var night_track: FallbackMusicManager.TRACKS

func _ready() -> void:
	if TimeCycle.day_progress < MUSIC_CHANGE_PROGRESS:
		FallbackMusicManager.play_music_track(day_track, FallbackMusicManager.FADE.BOTH)
	else:
		FallbackMusicManager.play_music_track(night_track, FallbackMusicManager.FADE.BOTH)
	
	TimeCycle.day_progress_changed.connect(_on_day_progress)
	
func _on_day_progress() -> void:
	if TimeCycle.day_progress < MUSIC_CHANGE_PROGRESS:
		FallbackMusicManager.play_music_track(day_track, FallbackMusicManager.FADE.BOTH)
	else:
		FallbackMusicManager.play_music_track(night_track, FallbackMusicManager.FADE.BOTH)
