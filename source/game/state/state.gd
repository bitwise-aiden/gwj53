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
	if Input.is_key_pressed(KEY_A): 
		_cube.rotate_y(-delta * 2)

	if Input.is_key_pressed(KEY_D): 
		_cube.rotate_y(+delta * 2)

	if Input.is_key_pressed(KEY_W):
		_cube.rotate_x(-delta * 2)

	if Input.is_key_pressed(KEY_S):
		_cube.rotate_x(+delta * 2)
