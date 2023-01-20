extends Label


# Lifecycle methods

func _ready() -> void:
	Event.connect("set_score_finished", self, "__update_score")
	__update_score(Setting.score_finished)


# Private methods

func __update_score(value: float) -> void:
	value = min(600.0, value)

	var seconds: float = fmod(value, 60.0)
	var minutes: int = int(value / 60.0)

	text = "Best: %02d:%05.2f" % [minutes, seconds]
