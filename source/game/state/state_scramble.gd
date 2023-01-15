class_name StateScramble extends State


# Private variables 

var __time_remaining: float = 4.0


# Lifecycle methods 

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	pass


# Public methods 

func process(delta: float) -> void: 
	.process(delta)
	
	_cube.rotate_face(
		__rand_face(),
		__rand_direction()
	)
	
	__time_remaining = max(0.0, __time_remaining - delta)
	
	if __time_remaining == 0.0: 
		Event.emit_signal("cube_scrambled")
		_completed = true


# Private methods 

func __rand_direction() -> int: 
	return Cube.Direction.CW if randi() % 2 == 0 else Cube.Direction.CCW


func __rand_face() -> int: 
	return randi() % Cube.FaceType.Max
