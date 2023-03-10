class_name StateReset extends State


# Private constants

const offset: Vector3 = Vector3.RIGHT * 10


# Private variables

var __bodies: Array = []
var __rotation: float = 0.0
var __speed: float = 0.3


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	Event.emit_signal("time_changed", 0.0)
	__reset()


# Public methods

func process(delta: float) -> void:
	.process(delta)

	__rotation += delta * __speed
	__speed += delta * 0.6

	for i in __bodies.size():
		__bodies[i].translation = offset.rotated(Vector3.UP, TAU / __bodies.size() * i + __rotation)
		__bodies[i].translation.y = sin(__rotation + TAU * i) * 1.0 - 0.5


# Private methods

func __reset() -> void:
	_cube.show_guide(false)

	var tween: SceneTreeTween = _tree.create_tween().set_parallel()

	var parts: Array	= _cube.parts.duplicate()
	parts.shuffle()

	Audio.play_effect(Audio.effect_explode)

	for i in parts.size():
		var part_mesh: MeshInstance = parts[i].mesh
		var body: KinematicBody = KinematicBody.new()

		body.translation = offset.rotated(Vector3.UP, TAU / parts.size() * i + __rotation)
		_tree.current_scene.add_child(body)

		var part_translation: Vector3 = part_mesh.global_translation
		var parent = part_mesh.get_parent()

		# This is when it is coming from the cube
		var part_collider: CollisionShape = parent.get_child(0 if parent is RigidBody else 1)
		parent.remove_child(part_collider)
		parts[i].add_child(part_collider)
		part_collider.transform = Transform.IDENTITY

		parent.remove_child(part_mesh)
		body.add_child(part_mesh)
		part_mesh.global_translation = part_translation

		var dest_translation = Vector3(
			randf() * 0.6 - 0.3,
			randf() * 0.6 - 0.3,
			randf() * 0.6 - 0.3
		)
		var dest_rotation = Vector3(
			randf() * TAU,
			randf() * TAU,
			randf() * TAU
		)

		tween.tween_property(
			part_mesh,
			"translation",
			dest_translation,
			0.5
		)

		tween.tween_property(
			part_mesh,
			"rotation",
			dest_rotation,
			0.5
		)

		__bodies.append(body)

	yield(tween, "finished")

	tween = _tree.create_tween()

	parts.shuffle()

	for part in parts:
		tween.tween_callback(
			self,
			"__disconnect",
			[part]
		)

		tween.tween_property(
			part.mesh,
			"transform",
			Transform.IDENTITY,
			0.2
		)

		tween.tween_callback(
			self,
			"__connect",
			[part]
		)

	yield(tween, "finished")
	yield(_tree.create_timer(1.0), "timeout")

	for part in parts:
		part.get_child(1).transform = Transform.IDENTITY
		part.get_child(2).transform = Transform.IDENTITY

	_cube.get_child(1).transform = Transform.IDENTITY

	_completed = true


func __connect(part: Part) -> void:
	Audio.play_effect(Audio.effect_attach)


func __disconnect(part: Part) -> void:
	var mesh: MeshInstance = part.mesh
	var body: KinematicBody = mesh.get_parent()

	var mesh_translation: Vector3 = mesh.global_translation
	body.remove_child(mesh)
	part.add_child(mesh)
	mesh.global_translation = mesh_translation
