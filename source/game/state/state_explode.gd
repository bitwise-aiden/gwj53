class_name StateExplode extends State


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	__explode()


# Private methods

func __explode() -> void:
	yield(__pulse(0.1, 0.1), "completed")
	yield(_tree.create_timer(1.0), "timeout")

	yield(__pulse(0.5, 0.1), "completed")
	yield(_tree.create_timer(0.75), "timeout")

	yield(__pulse(1.0, 0.1), "completed")
	yield(_tree.create_timer(0.5), "timeout")

#	yield(__move(0.3, 0.1), "completed")

	var origin: Vector3 = _cube.global_translation

	for part in _cube.parts:
		var rigid_body: RigidBody = RigidBody.new()
		rigid_body.global_transform = part.global_transform
		rigid_body.mass = 10.0
		rigid_body.weight *= 5.0

		_tree.current_scene.add_child(rigid_body)
		rigid_body.global_transform = part.global_transform
		rigid_body.look_at(_cube.translation, Vector3.UP)

		var part_collider: CollisionShape = part.get_child(1)
		var collider_rotation = part_collider.global_rotation
		var part_mesh: MeshInstance = part.get_child(2)
		var mesh_rotation = part_mesh.global_rotation

		part.remove_child(part_collider)
		rigid_body.add_child(part_collider)
		part_collider.global_rotation = collider_rotation

		part.remove_child(part_mesh)
		rigid_body.add_child(part_mesh)
		part_mesh.global_rotation = mesh_rotation

		rigid_body.collision_mask |= 1 << 2
		rigid_body.collision_layer |= 1 << 2

		var direction: Vector3 = rigid_body.global_translation - origin
		rigid_body.apply_impulse(rigid_body.global_translation, direction * (randf() * 200.0 + 800.0))

	_cube.reset_parts()
	_cube.show_guide(true, 0.5, 1.0)

	Event.emit_signal("cube_exploded")
	_completed = true


func __pulse(scalar: float, duration: float) -> void:
	yield(__move(+scalar, duration), "completed")
	yield(__move(-scalar, duration), "completed")


func __move(scalar: float, duration: float) -> void:
	var origin: Vector3 = _cube.translation

	var tween: SceneTreeTween = _tree.create_tween().set_parallel().set_ease(Tween.EASE_OUT)

	for part in _cube.parts:
		var direction: Vector3 = (part.translation - origin).normalized()

		var _result = tween.tween_property(
			part,
			"translation",
			part.translation + direction * scalar,
			duration
		)

	yield(tween, "finished")
