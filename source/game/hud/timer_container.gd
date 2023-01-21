extends Control


# Private variables

onready var __tween: Tween

var __origin: float
var __destination: float

# Lifecycle methods

func _ready() -> void:
	Event.connect("game_start", self, "__start")
	Event.connect("game_pause", self, "__pause")

	__destination = rect_position.y
	rect_position.y -= 250.0
	__origin = rect_position.y

	__tween = Tween.new()
	add_child(__tween)


# Private methods

func __start() -> void:
	yield(get_tree().create_timer(Globals.TIME_START_TRANSITION), "timeout")
	__tween.interpolate_property(
		self,
		"rect_position:y",
		__origin,
		__destination,
		0.2
	)
	__tween.start()


func __pause(value: bool) -> void:
	__tween.remove(self, "rect_position:y")
	__tween.interpolate_property(
		self,
		"rect_position:y",
		rect_position.y,
		__origin if value else __destination,
		0.2
	)
	__tween.start()
