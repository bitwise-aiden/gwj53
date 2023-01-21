class_name StateExplode extends State


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	__explode()


# Private methods

func __explode() -> void:
	yield(__pulse(0.1, 0.1), "completed")
	yield(_tree.create_timer(1.0), "timeout")

	yield(__pulse(0.2, 0.1), "completed")
	yield(_tree.create_timer(0.5), "timeout")

	yield(__pulse(0.3, 0.1), "completed")
	yield(_tree.create_timer(0.25), "timeout")

	yield(__pulse(0.5, 0.1), "completed")
	yield(_tree.create_timer(0.1), "timeout")

	var origin: Vector3 = _cube.global_translation

	Audio.play_effect(Audio.effect_explode)

	for part in _cube.parts:
		var rigid_body: RigidBody = part.to_rigid_body()

		var direction: Vector3 = rigid_body.global_translation - origin
		rigid_body.apply_impulse(rigid_body.global_translation, direction * (randf() * 200.0 + 800.0))

	_cube.reset_parts()
	_cube.show_guide(true, 0.5, 1.0)

	Event.emit_signal("cube_exploded")
	_completed = true


func __pulse(scalar: float, duration: float) -> void:
	Audio.play_effect(Audio.effect_pulse)
	yield(__move(+scalar, duration), "completed")

	Audio.play_effect(Audio.effect_pulse)
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
