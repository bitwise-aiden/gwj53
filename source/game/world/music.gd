extends AudioStreamPlayer

# Public variables

export(AudioStreamOGGVorbis) var track_lobby: AudioStreamOGGVorbis
export(AudioStreamOGGVorbis) var track_game: AudioStreamOGGVorbis


# Lifecycle methods

func _ready() -> void:
	Event.connect("game_ready", self, "__change_track")

	stream = track_lobby
	play()



func __change_track() -> void:
	var tween: SceneTreeTween = create_tween().set_trans(Tween.TRANS_LINEAR)

	var current_volume: float = volume_db

	tween.tween_property(
		self,
		"volume_db",
		-80.0,
		1.0
	)

	yield(tween, "finished")
	stream = track_game
	play()

	volume_db = current_volume
