extends Node


# Public variables

var effect_select: AudioStreamOGGVorbis = preload("res://assets/effects/join.ogg")
var effect_issue: AudioStreamOGGVorbis = preload("res://assets/effects/jump.ogg")
var effect_start: AudioStreamOGGVorbis = preload("res://assets/effects/select.ogg")
var effect_go: AudioStreamOGGVorbis = preload("res://assets/effects/go.ogg")
var effect_countdown: AudioStreamOGGVorbis = preload("res://assets/effects/countdown.ogg")
var effect_pulse: AudioStreamOGGVorbis = preload("res://assets/effects/pulse.ogg")
var effect_explode: AudioStreamOGGVorbis = preload("res://assets/effects/explode.ogg")
var effect_attach: AudioStreamOGGVorbis = preload("res://assets/effects/rotate_1.ogg")


# Private variables

var __players_effects: Array = []
var __player_ui: AudioStreamPlayer


# Lifecycle methods

func _ready() -> void:
	Event.connect("set_audio_volume", self, "__update_volume")

	for i in 10:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.bus = "Effects"
		player.pitch_scale = 0.9 + randf() * 0.2

		add_child(player)

		__players_effects.append(player)

	__player_ui = AudioStreamPlayer.new()
	__player_ui.pause_mode = PAUSE_MODE_PROCESS
	__player_ui.bus = "Effects"

	add_child(__player_ui)


# Public methods

func play_effect(effect: AudioStreamOGGVorbis) -> void:
	for player in __players_effects:
		if player.playing:
			continue

		player.stream = effect
		player.play()


func play_effect_ui(effect: AudioStreamOGGVorbis) -> void:
	if __player_ui.playing:
		return

	__player_ui.stream = effect
	__player_ui.play()


# Private methods

func __update_volume(value: int) -> void:
	var volume: float = linear2db(min(3, value) * 0.33)
	AudioServer.set_bus_volume_db(0, volume)
