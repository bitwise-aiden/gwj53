extends Spatial


# Private variables 

onready var __cube = $"%cube"


# Lifecycle methods

func _ready() -> void:
	randomize()


func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_A): 
		__cube.rotate_y(-delta * 2)

	if Input.is_key_pressed(KEY_D): 
		__cube.rotate_y(+delta * 2)

	if Input.is_key_pressed(KEY_W):
		__cube.rotate_x(-delta * 2)

	if Input.is_key_pressed(KEY_S):
		__cube.rotate_x(+delta * 2)
	
	if Input.is_key_pressed(KEY_ENTER): 
		__cube.rotate_face(randi() % Cube.FaceType.Max, Cube.Direction.CW)
