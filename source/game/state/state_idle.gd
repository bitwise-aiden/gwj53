class_name StateIdle extends State


# Private variables

var __move_cooldown: float = 0.0


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	var _result = Event.connect("game_start", self, "set", ["_completed", true])


# Public methods

func process(delta: float) -> void:
	var rotation_orig: Vector3 = _cube.rotation

	.process(delta)

	if rotation_orig != _cube.rotation:
		__move_cooldown = 2.0

	if __move_cooldown == 0.0:
		_cube.rotate_y(delta * 0.5)

	__move_cooldown = max(0.0, __move_cooldown - delta)

