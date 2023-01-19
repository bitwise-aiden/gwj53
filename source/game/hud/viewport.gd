extends ViewportContainer


# Lifecycle methods

func _ready() -> void:
	Event.connect("game_start", self, "__start")


# Private methods

func __start() -> void:
	var tween: SceneTreeTween = create_tween()

	tween.tween_method(
		self,
		"__set_strength",
		1.0,
		0.0,
		0.2
	)

func __set_strength(value: float) -> void:
	material.set_shader_param("iTotalStrength", value)
