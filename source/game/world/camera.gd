extends Camera


# Private variables

onready var __origin: Vector3 = translation

# Lifecycle methods

func _ready():
	translation.z += 5.0
	look_at(Vector3(0.0, -0.5, 0.0), Vector3.UP)

	Event.connect("game_start", self, "__start")


# Private methods

func __start():
	look_at(Vector3(0.0, -3.0, 0.0), Vector3.UP)
	var dest_rotation: Vector3 = rotation
	look_at(Vector3(0.0, -0.5, 0.0), Vector3.UP)

	var tween: SceneTreeTween = create_tween().set_parallel()

	tween.tween_property(
		self,
		"translation",
		__origin,
		0.2
	)

	tween.tween_property(
		self,
		"rotation",
		dest_rotation,
		0.2
	)
