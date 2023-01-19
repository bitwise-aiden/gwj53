extends TextureRect


# Lifecycle methods

func _ready() -> void:
	Event.connect("game_start", self, "__start")


# Private methods

func __start() -> void:
	print("What")
	var tween: SceneTreeTween = create_tween()

	tween.tween_property(
		self,
		"rect_position",
		rect_position + Vector2.UP * 250.0,
		Globals.TIME_START_TRANSITION
	)
