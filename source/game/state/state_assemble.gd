class_name StateAssemble extends State

enum Action { Select = 0, Place, Max }


# Private variables 

var __action: int = Action.Place
var __over: RigidBody


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	pass


func process(delta: float) -> void:
	.process(delta)
	
	match self.__action:
		Action.Select: 
			__select()
		Action.Place:
			__place(delta)


# Protected methods 

func _handle_input(delta: float) -> void: 
	._handle_input(delta)
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT): 
		if __action == Action.Select && __over:
			__action = Action.Place
	elif __action == Action.Place: 
		__action = Action.Select
	
	if __over: 
		print(__over)

# Private methods 

func __select() -> void: 
	var result: Dictionary = __intersect(false)
	__over = result.get("collider", null)


func __place(delta: float) -> void: 
	var result: Dictionary = __intersect(true)
	print(result)
	
#	__over.translation = lerp(__over.translation, result["position"], 0.5)


func __intersect(area: bool) -> Dictionary: 
	var mouse_position: Vector2 = _cube.get_viewport().get_mouse_position()
	var camera: Camera = _cube.get_viewport().get_camera()
	var space_state: PhysicsDirectSpaceState = _cube.get_world().direct_space_state

	var ray_origin: Vector3 = camera.project_ray_origin(mouse_position)
	var ray_normal: Vector3 = camera.project_ray_normal(mouse_position) * 100.0
	ray_origin += ray_normal.normalized() * 10.0

	return space_state.intersect_ray(ray_origin, ray_origin + ray_normal, [], 1 << 3, !area, area)
