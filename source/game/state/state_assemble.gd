class_name StateAssemble extends State

enum Action { Select = 0, Place, Max }


# Private variables

var __action: int = Action.Select
var __over: RigidBody

var __camera: Camera
var __camera_origin: Vector3
var __camera_zoom: Vector3


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	__camera = _cube.get_viewport().get_camera()
	__camera_origin = __camera.translation
	__camera_zoom = (Vector3(0.0, -3.0, 0.0) - __camera_origin).normalized() * 3.0 + __camera_origin


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
			__over.sleeping = true
			__action = Action.Place
			__pan(__camera_zoom)
	elif __action == Action.Place:
		__over.sleeping = false

		var direction: Vector3 = (__over.global_translation - _cube.global_translation)

		__action = Action.Select
		__pan(__camera_origin)


# Private methods

func __intersect(collision_mask: int) -> Dictionary:
	var mouse_position: Vector2 = _cube.get_viewport().get_mouse_position()
	var space_state: PhysicsDirectSpaceState = _cube.get_world().direct_space_state

	var ray_origin: Vector3 = __camera.project_ray_origin(mouse_position)
	var ray_normal: Vector3 = __camera.project_ray_normal(mouse_position) * 100.0
	ray_origin += ray_normal.normalized() * 5.0

	return space_state.intersect_ray(ray_origin, ray_origin + ray_normal, [], collision_mask)


func __pan(position: Vector3) -> void:
	var tween = _cube.create_tween()
	tween.tween_property(
		__camera,
		"translation",
		position,
		0.5
	)

func __place(delta: float) -> void:
	var result: Dictionary = __intersect(1 << 3)

	if result.empty():
		return

	__over.translation = lerp(__over.translation, result["position"], 0.5)
	__over.look_at(_cube.translation, Vector3.UP)


func __select() -> void:
	var result: Dictionary = __intersect(1 << 2)
	__over = result.get("collider", null)
