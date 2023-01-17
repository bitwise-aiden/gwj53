class_name State extends Resource


# Public variables

var _cube: Cube
var _completed: bool = false
var _tree: SceneTree


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube) -> void:
	_cube = cube
	_tree = tree


# Public methods

func is_complete() -> bool:
	return _completed


func process(delta: float) -> void:
	_handle_input(delta)


# Protected methods

func _handle_input(delta: float) -> void:
	if Input.is_action_pressed("rotate_left"):
		_cube.rotate_y(-delta * 2)

	if Input.is_action_pressed("rotate_right"):
		_cube.rotate_y(+delta * 2)

	if Input.is_action_pressed("rotate_forward"):
		_cube.rotate_x(-delta * 2)

	if Input.is_action_pressed("rotate_backward"):
		_cube.rotate_x(+delta * 2)
