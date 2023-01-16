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

	var origin: Vector3 = _cube.translation

	for part in _cube.parts:
		var part_copy: Part = part.duplicate()

		var rigid_body: RigidBody = RigidBody.new()
		rigid_body.transform = part_copy.transform
		rigid_body.rotation += _cube.rotation
		rigid_body.mass = 10.0
		rigid_body.weight *= 5.0
		rigid_body.add_to_group("broken_part")

		_tree.current_scene.add_child(rigid_body)

		var part_collider: CollisionShape = part_copy.get_child(0)
		var part_mesh: MeshInstance = part_copy.get_child(1)

		part_copy.remove_child(part_collider)
		part_copy.remove_child(part_mesh)

		rigid_body.add_child(part_collider)
		rigid_body.add_child(part_mesh)

		rigid_body.collision_mask |= 1 << 3
		rigid_body.collision_layer |= 1 << 3

		var direction: Vector3 = rigid_body.translation - origin
		rigid_body.apply_impulse(rigid_body.translation, direction * 500.0)

		part.visible = false

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

		tween.tween_property(
			part,
			"translation",
			part.translation + direction * scalar,
			duration
		)

	yield(tween, "finished")
