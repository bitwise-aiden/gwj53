class_name StateScramble extends State


# Private variables

var __time_remaining: float = 4.0


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	Event.emit_signal("time_changed", 0.0)

	for i in 10:
		yield(
			_cube.rotate_face(
				__rand_face(),
				__rand_direction()
			),
			"completed"
		)

	_completed = true


# Private methods

func __rand_direction() -> int:
	return Cube.Direction.CW if randi() % 2 == 0 else Cube.Direction.CCW


func __rand_face() -> int:
	return randi() % Cube.FaceType.Max
