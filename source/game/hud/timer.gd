extends Label


# Private variables

var __tween: Tween

# Lifecycle methods

func _ready() -> void:
	Event.connect("time_changed", self, "__update_time")
	Event.connect("game_finished", self, "__blink")
	Event.connect("game_restart", self, "__blink", [false])

	__tween = Tween.new()
	__tween.repeat = true
	add_child(__tween)


# Private methods

func __update_time(value: float) -> void:
	value = min(600.0, value)

	match value:
		600.0: __blink(true)
		0.0: __blink(false)

	var seconds: float = fmod(value, 60.0)
	var minutes: int = int(value / 60.0)

	text = "%02d:%05.2f" % [minutes, seconds]


func __blink(blink: bool = true) -> void:
	if !blink:
		__tween.stop_all()
		visible = true
	elif !__tween.is_active():
		__tween.interpolate_method(
			self,
			"__blink_visibility",
			0.0,
			0.7,
			0.7
		)
		__tween.start()


func __blink_visibility(value: float) -> void:
	visible = value < 0.5
