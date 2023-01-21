extends Label


# Private variables

var __tween: Tween

var __origin: Vector2
var __destination: Vector2


# Lifecycle methods

func _ready() -> void:
	Event.connect("game_start", self, "__show", [false])
	Event.connect("game_ready", self, "__show", [false])
	Event.connect("cube_scrambled", self, "__show", [true])

	__tween = Tween.new()
	add_child(__tween)

	__origin = rect_position
	__destination = rect_position + Vector2.DOWN * 250.0

	while true:
		yield(get_tree().create_timer(0.5), "timeout")
		visible = false

		yield(get_tree().create_timer(0.2), "timeout")
		visible = true


# Private methods

func __show(value: bool) -> void:
	visible = true

	__tween.remove(self, "rect_position")
	__tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		__origin if value else __destination,
		0.2
	)
	__tween.start()
