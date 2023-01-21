extends Camera


# Private variables

var __origin: Vector3
var __origin_rotation: Vector3
var __zoomed_out: Vector3
var __zoomed_out_rotation: Vector3

var __tween: Tween


# Lifecycle methods

func _ready():
	__origin = translation
	translation.z += 5.0

	look_at(Vector3(0.0, -3.0, 0.0), Vector3.UP)
	__origin_rotation = rotation

	look_at(Vector3(0.0, -0.5, 0.0), Vector3.UP)

	__zoomed_out = translation
	__zoomed_out_rotation = rotation

	__tween = Tween.new()
	add_child(__tween)

	Event.connect("game_start", self, "__start", [false])
	Event.connect("game_pause", self, "__start")


# Private methods

func __start(value: bool):
	__tween.remove(self, "translation")
	__tween.interpolate_property(
		self,
		"translation",
		translation,
		__zoomed_out if value else __origin,
		Globals.TIME_START_TRANSITION
	)

	__tween.remove(self, "rotation")
	__tween.interpolate_property(
		self,
		"rotation",
		rotation,
		__zoomed_out_rotation if value else __origin_rotation,
		Globals.TIME_START_TRANSITION
	)

	__tween.start()
