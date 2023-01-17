class_name StateAssemble extends State

enum Action { Select = 0, Place, Max }


# Private variables

var __action: int = Action.Select
var __camera: Camera
var __camera_origin: Vector3
var __camera_zoom: Vector3
var __closest: Part
var __over: RigidBody
var __over_offset: Vector3
var __over_rotation: float
var __rotating_part: bool
var __part_origins: Dictionary = {}


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	__camera = _cube.get_viewport().get_camera()
	__camera_origin = __camera.translation
	__camera_zoom = (Vector3(0.0, -3.0, 0.0) - __camera_origin).normalized() * 3.0 + __camera_origin

	for part in _cube.parts:
		__part_origins[part.name] = part.translation


func process(delta: float) -> void:
	.process(delta)

	match self.__action:
		Action.Select:
			__select()
		Action.Place:
			__place()


# Protected methods

func _handle_input(delta: float) -> void:
	._handle_input(delta)

	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if __action == Action.Select && __over:
			__over.sleeping = true
			__action = Action.Place
			__pan(__camera_zoom)
	elif __action == Action.Place && !__rotating_part:
		__over.sleeping = false
		__over_offset = Vector3.ZERO
		__over_rotation = 0.0
		__action = Action.Select
		__pan(__camera_origin)

		if __closest:
			__closest.translation = __part_origins[__closest.name]

	if __action == Action.Place && Input.is_action_just_pressed("rotate_part"):
		__rotate_part()


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


func __place() -> void:
	var result: Dictionary = __intersect(1 << 3)

	if result.empty():
		return

	__over.translation = lerp(__over.translation, result["position"] + __over_offset, 0.5)
	__over.look_at(_cube.translation, Vector3.UP)

	var axis: Vector3 = (__over.translation - _cube.translation).normalized()
	__over.rotate(axis, __over_rotation)

	var closest: Part
	var closest_angle: float = INF

	var dir_over: Vector3 = __over.global_translation - _cube.global_translation

	for part in _cube.parts:
		var dir_part: Vector3 = part.global_translation - _cube.global_translation

		var angle: float = dir_part.angle_to(dir_over)

		if closest_angle > angle:
			closest = part
			closest_angle = angle

	if !closest || closest == __closest:
		return

	var tween: SceneTreeTween = _cube.create_tween().set_parallel()

	if __closest:
		__closest.translation = __part_origins[__closest.name]
#		var old_origin: Vector3 = __part_origins[__closest.name]
#		tween.tween_property(
#			__closest,
#			"translation",
#			old_origin,
#			0.1
#		)
#
	__closest = closest

	var origin: Vector3 = __part_origins[__closest.name]
	var destination: Vector3 = _cube.translation + (origin - _cube.translation) * 1.2

	__closest.translation = destination
#
#	tween.tween_property(
#		__closest,
#		"translation",
#		destination,
#		0.2
#	)


func __rotate_part() -> void:
	if __rotating_part:
		return

	var tween: SceneTreeTween = _cube.create_tween()

	tween.set_ease(Tween.EASE_OUT).tween_method(
		self,
		"__rotate_part_offset",
		0.0,
		1.0,
		0.1
	)

	tween.tween_interval(0.1)

	var face_count: float = __over.get_child(1).get_child_count()
	var angle: float = TAU / face_count

	tween.set_ease(Tween.EASE_IN_OUT).tween_method(
		self,
		"__rotate_part_rotation",
		__over_rotation,
		__over_rotation + angle,
		0.15
	)

	tween.set_ease(Tween.EASE_IN).parallel().tween_method(
		self,
		"__rotate_part_offset",
		1.0,
		0.0,
		0.05
	)


func __rotate_part_offset(step: float) -> void:
	var direction: Vector3 = (__over.translation - _cube.translation).normalized()
	var position: Vector3 = __intersect(1 << 3)["position"]

	__over_offset = direction * 0.3 * step


func __rotate_part_rotation(value: float) -> void:
	__over_rotation = value


func __select() -> void:
	var result: Dictionary = __intersect(1 << 2)
	__over = result.get("collider", null)
