class_name StateAssemble extends State

enum Action { Select = 0, Place, Max }


# Private variables

var __action: int = Action.Select
var __camera: Camera
var __camera_origin: Vector3
var __camera_zoom: Vector3
var __closest: Part
var __over: Spatial
var __over_destination: Transform
var __over_offset: Vector3
var __over_rotation: float
var __rotating_part: bool
var __part_origins: Dictionary = {}
var __timer: float = 0.0

var __to_green: Array = []
var __to_white: Array = []


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	__camera = _cube.get_viewport().get_camera()
	__camera_origin = __camera.translation
	__camera_zoom = (Vector3(0.0, -3.0, 0.0) - __camera_origin).normalized() * 3.0 + __camera_origin

	for part in _cube.parts:
		__part_origins[part.name] = part.translation
		__to_white.append(part.get_child(0))

	Event.emit_signal("time_changed", __timer)


func process(delta: float) -> void:
	.process(delta)

	match self.__action:
		Action.Select:
			__select()
		Action.Place:
			__place()

	_completed = true

	for part in _cube.parts:
		_completed = _completed && part.get_child_count() > 1

	if _completed:
		Event.emit_signal("game_finished")

		if __over is RigidBody:
			__over.get_child(1).show_hover(false)
		elif __over is KinematicBody:
			__over.get_child(2).show_hover(false)

	__timer += delta
	Event.emit_signal("time_changed", __timer)

	var green: Color = Color("#b8ff66")
	for guide in __to_green:
		var material: SpatialMaterial = guide.get_active_material(0)
		material.albedo_color = lerp(material.albedo_color, green, 0.15)
		material.albedo_color.a = 0.75

	var white: Color = Color.white
	for guide in __to_white:
		var material: SpatialMaterial = guide.get_active_material(0)
		material.albedo_color = lerp(material.albedo_color, white, 0.15)
		material.albedo_color.a = 0.75


# Protected methods

func _handle_input(delta: float) -> void:
	._handle_input(delta)

	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if __action == Action.Select && __over:
			__action = Action.Place
			__pan(__camera_zoom)

			if __over is KinematicBody:
				__over = __over.to_rigid_body()

			Audio.play_effect(Audio.effect_attach)
			_cube.show_partial_guide(__over.get_child(1).get_child_count())
	elif __action == Action.Place && !__rotating_part:
		if __over is RigidBody:
			__over.get_child(1).show_hover(false)

			if __closest:
				__attach()

				__closest.get_child(0).translation = Vector3.ZERO
				__closest = null

				__over.queue_free()
				__over = null
			else:
				var direction: Vector3 = (__over.translation - _cube.translation).normalized()
				__over.linear_velocity = Vector3.ZERO
				__over.apply_impulse(__over.translation, direction * 1000.0)

				__over_offset = Vector3.ZERO
				__over_rotation = 0.0
		else:
			__over.get_child(2).show_hover(false)

		__over_offset = Vector3.ZERO
		__over_rotation = 0.0
		_cube.show_guide(true)
		__action = Action.Select
		__pan(__camera_origin)

	if __action == Action.Place:
		if Input.is_action_just_pressed("part_left"):
			__rotate_part(true)
		elif Input.is_action_just_pressed("part_right"):
			__rotate_part(false)


func _handle_rotation(delta: float, orig: Vector3) -> void:
	# Overrides the base functionality to not rotate as auto
	pass


# Private methods

func __attach() -> void:
	__closest.attach(__over, __over_rotation)

	Audio.play_effect(Audio.effect_attach)


func __intersect(collision_mask: int) -> Dictionary:
	var mouse_position: Vector2 = _cube.get_viewport().get_mouse_position()
	var space_state: PhysicsDirectSpaceState = _cube.get_world().direct_space_state

	var ray_origin: Vector3 = __camera.project_ray_origin(mouse_position)
	var ray_normal: Vector3 = __camera.project_ray_normal(mouse_position) * 100.0
	ray_origin += ray_normal.normalized() * 5.0

	return space_state.intersect_ray(ray_origin, ray_origin + ray_normal, [], collision_mask)


func __pan(position: Vector3) -> void:
	var tween = _tree.create_tween()
	tween.tween_property(
		__camera,
		"translation",
		position,
		0.5
	)


func __place() -> void:
	# Can only place as Rigid Body, no need to check for __over type
	var result: Dictionary = __intersect(1 << 3)
	if result.empty():
		return

	var place_translation: Vector3 = result["position"] + __over_offset

	var closest: Part = __find_closest()

	if closest != __closest:
		if __closest:
			__closest.get_child(0).translation = Vector3.ZERO

			var index = __to_green.find(__closest.get_child(0))
			if index > -1:
				__to_green.remove(index)
			__to_white.append(__closest.get_child(0))

		if closest:
			# Update guide position
			var origin: Vector3 = __part_origins[closest.name]
			var destination: Vector3 = closest.face_direction

			closest.get_child(0).translation = destination

			var index = __to_white.find(closest.get_child(0))
			if index > -1:
				__to_white.remove(index)
			__to_green.append(closest.get_child(0))

	__closest = closest

	if !__closest:
		__over.translation = place_translation
		return
	else:
		var mesh: MeshInstance = __over.get_child(1)

		__over.global_transform = __closest.global_transform

		var destination_basis: Basis = __closest.calculate_basis(mesh)
		destination_basis = destination_basis.rotated(__closest.face_direction, __over_rotation)
		destination_basis = destination_basis.orthonormalized()

		mesh.transform.basis = mesh.transform.basis.orthonormalized().slerp(destination_basis, 0.15)

		__over.translation = place_translation - _cube.translation


func __find_closest() -> Part:
	var closest: Part
	var closest_angle: float = INF

	var dir_over: Vector3 = __over.global_translation - _cube.global_translation
	var face_count: int = __over.get_child(1).get_child_count()

	for part in _cube.parts:
		if part.get_child_count() > 1:
			continue

		if part.face_count != face_count:
			continue

		var dir_part: Vector3 = part.global_translation - _cube.global_translation

		var angle: float = dir_part.angle_to(dir_over)

		if angle > PI * 0.15:
			continue

		if closest_angle > angle:
			closest = part
			closest_angle = angle

	return closest


func __rotate_part(cw: bool) -> void:
	if __rotating_part:
		return

	__rotating_part = true

	var tween: SceneTreeTween = _tree.create_tween()

	tween.set_ease(Tween.EASE_OUT).tween_method(
		self,
		"__rotate_part_offset",
		0.0,
		1.0,
		0.1
	)

	tween.tween_interval(0.1)

	var face_count: float = __over.get_child(1).get_child_count()

	if face_count > 1:
		var angle: float = TAU / face_count
		if !cw:
			angle *= -1

		tween.set_parallel()
		tween.set_ease(Tween.EASE_IN_OUT).tween_method(
			self,
			"__rotate_part_rotation",
			__over_rotation,
			__over_rotation + angle,
			0.15
		)

	tween.set_ease(Tween.EASE_IN).tween_method(
		self,
		"__rotate_part_offset",
		1.0,
		0.0,
		0.05
	)

	yield(tween, "finished")

	__rotating_part = false


func __rotate_part_offset(step: float) -> void:
	var direction: Vector3 = (__over.translation - _cube.translation).normalized()
	var position: Vector3 = __intersect(1 << 3)["position"]

	__over_offset = direction * 0.3 * step


func __rotate_part_rotation(value: float) -> void:
	__over_rotation = value


func __select() -> void:
	var result: Dictionary = __intersect(1 << 2)
	if __over:
		if __over is RigidBody:
			__over.get_child(1).show_hover(false)
		else:
			__over.get_child(2).show_hover(false)

	__over = result.get("collider", null)

	if __over:
		if __over is RigidBody:
			__over.get_child(1).show_hover(true)
		else:
			__over.get_child(2).show_hover(true)
