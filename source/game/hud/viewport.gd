extends ViewportContainer


# Private variables

var __tween: Tween

# Lifecycle methods

func _ready() -> void:
	Event.connect("game_start", self, "__start")
	Event.connect("game_pause", self, "__pause")

	__tween = Tween.new()
	add_child(__tween)


# Private methods

func __start() -> void:
	__tween.interpolate_method(
		self,
		"__set_strength",
		1.0,
		0.0,
		Globals.TIME_START_TRANSITION
	)
	__tween.start()


func __pause(value: bool) -> void:
	var from: float = 0.0 if value else 1.0
	var to: float = 1.0 if value else 0.0

	__tween.remove(self, "__set_strength")
	__tween.interpolate_method(
		self,
		"__set_strength",
		from,
		to,
		0.2
	)
	__tween.start()


func __set_strength(value: float) -> void:
	material.set_shader_param("iTotalStrength", value)
