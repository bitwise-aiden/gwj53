class_name StateComplete extends State


# Public variables

var original_translations: Dictionary = {}


# Private variables

var __celebrating: bool = false


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube):
	for part in _cube.parts:
		original_translations[part.name] = part.translation

# Public methods

func process(delta: float) -> void:
	.process(delta)

	__celebrate()


# Private methods

func __celebrate() -> void:
	if __celebrating:
		return

	__celebrating = true

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

	__celebrating = false
