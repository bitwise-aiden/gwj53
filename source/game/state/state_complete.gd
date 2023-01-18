class_name StateComplete extends State


# Private variables

var __can_celebrate: bool = false

# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube):
	yield(_tree.create_timer(1.0), "timeout")

	_cube.show_guide(false)

	__can_celebrate = true


# Public methods

func process(delta: float) -> void:
	.process(delta)

	__celebrate()


# Private methods

func __celebrate() -> void:
	if !__can_celebrate:
		return

	var tween: SceneTreeTween = _tree.create_tween().set_parallel()

	for part in _cube.parts:
		var direction: Vector3 = part.translation - _cube.translation

		tween.tween_property(
			part,
			"translation",
			direction * 1.2,
			randf() * 0.3
		)

	yield(tween, "finished")

	tween = _tree.create_tween().set_parallel()

	for part in _cube.parts:
		var direction: Vector3 = part.translation - _cube.translation

		tween.tween_property(
			part,
			"translation",
			direction / 1.2,
			randf() * 0.3
		)

	yield(tween, "finished")
