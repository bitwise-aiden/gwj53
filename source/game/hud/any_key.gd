extends TextureRect


# Lifecycle methods

func _ready() -> void:
	Event.connect("game_start", self, "__start")

	while true:
		yield(get_tree().create_timer(0.5), "timeout")
		visible = false

		yield(get_tree().create_timer(0.2), "timeout")
		visible = true


# Private methods

func __start() -> void:
	visible = true

	var tween: SceneTreeTween = create_tween()

	tween.tween_property(
		self,
		"rect_position",
		rect_position + Vector2.DOWN * 250.0,
		0.2
	)

