extends Node


# Private variables

var player_music: AudioStreamPlayer


# Lifecycle methods

func _ready() -> void:
	player_music = AudioStreamPlayer.new()
	player_music.set_bus("Music")

	add_child(player_music)

	Event.connect("set_audio_volume", self, "__update_volume")


# Public methods

func play_music(stream: AudioStream) -> void:
	player_music.stream = stream
	player_music.play()


# Private methods

func __update_volume(value: int) -> void:
	var volume: float = linear2db(min(4, value) * 0.25)
	AudioServer.set_bus_volume_db(0, volume)
