extends Control


# Lifecycle methods

func _ready() -> void:
	Event.connect("game_start", self, "__start")

	self.rect_position.y -= 250.0


# Private methods

func __start() -> void:
	var tween: SceneTreeTween = create_tween()

	tween.tween_interval(Globals.TIME_START_TRANSITION)
	tween.tween_property(
		self,
		"rect_position:y",
		rect_position.y + 250.0,
		0.2
	)
