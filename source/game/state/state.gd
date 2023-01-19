class_name State extends Resource


# Protected variables

var _cube: Cube
var _completed: bool = false
var _tree: SceneTree


# Private variables

var __move_cooldown: float = 0.0


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube) -> void:
	_cube = cube
	_tree = tree


# Public methods

func is_complete() -> bool:
	return _completed


func process(delta: float) -> void:
	var rotation_orig: Vector3 = _cube.rotation

	_handle_input(delta)

#	if rotation_orig != _cube.rotation:
#		__move_cooldown = 2.0
#
#	if __move_cooldown == 0.0:
#		_cube.rotate_y(delta * 0.5)
#
#	__move_cooldown = max(0.0, __move_cooldown - delta)


# Protected methods

func _handle_input(delta: float) -> void:
	if Input.is_action_pressed("cube_left"):
		_cube.rotate_y(-delta * 2)

	if Input.is_action_pressed("cube_right"):
		_cube.rotate_y(+delta * 2)

	if Input.is_action_pressed("cube_up"):
		_cube.rotate_x(-delta * 2)

	if Input.is_action_pressed("cube_down"):
		_cube.rotate_x(+delta * 2)
