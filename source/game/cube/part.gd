class_name Part extends KinematicBody


# Public variables

onready var centre: MeshInstance = $centre
onready var face_count: int = $mesh.get_child_count()
onready var mesh: MeshInstance = $mesh

var face_direction: Vector3 = Vector3.ZERO


# Lifecycle methods

func _ready() -> void:
	for face in mesh.get_children():
		face_direction += face.translation

	face_direction = face_direction.normalized()

#	var to: Vector3 = (global_translation - get_parent().global_translation).normalized()
#	var from: Vector3 = Vector3.ZERO
#
#	for face in mesh.get_children():
#		from += face.translation
#
#	from = from.normalized()
#
#	print("to: %s" % to)
#	print("from: %s" % from)
#	print("before: %s" % mesh.rotation)
#	mesh.transform.basis *= Basis(Quat(from).slerp(Quat(to), 1))
#	print("after: %s" % mesh.rotation)

	var to: Vector3 = face_direction.normalized()
	var from: Vector3 = Vector3.ZERO

	for face in mesh.get_children():
		from += face.translation

	from = from.normalized()

	if abs(to.y) < 0.001:
		var proj_to_y: Vector3 = to - (to.dot(Vector3.UP)) * Vector3.UP
		var proj_from_y: Vector3 = from - (from.dot(Vector3.UP)) * Vector3.UP

		mesh.rotate_y(proj_from_y.angle_to(proj_to_y))

	if abs(to.x) < 0.001:
		var proj_to_x: Vector3 = to - (to.dot(Vector3.UP)) * Vector3.UP
		var proj_from_x: Vector3 = from - (from.dot(Vector3.UP)) * Vector3.UP

		mesh.rotate_x(proj_from_x.angle_to(proj_to_x))

	if abs(to.z) < 0.001:
		var proj_to_z: Vector3 = to - (to.dot(Vector3.UP)) * Vector3.UP
		var proj_from_z: Vector3 = from - (from.dot(Vector3.UP)) * Vector3.UP

		mesh.rotate_z(proj_from_z.angle_to(proj_to_z))



# Public methods

func attach(from: PhysicsBody) -> void:
	if from is RigidBody:
		var part_collider: CollisionShape = from.get_child(0)
		var part_mesh: MeshInstance = from.get_child(1)

		from.remove_child(part_collider)
		add_child(part_collider)

		from.remove_child(part_mesh)
		add_child(part_mesh)

		part_collider.transform = Transform.IDENTITY
		part_mesh.transform = Transform.IDENTITY

		rotate_toward(part_mesh, 1.0)


func rotate_toward(mesh: MeshInstance, weight: float) -> void:
	var to: Vector3 = face_direction.normalized()
	var from: Vector3 = __calc_from(mesh)

	for y in 4:
		for x in 4:
			for z in 4:
				mesh.rotation = Vector3.ZERO
				mesh.rotate(Vector3.UP, PI * 0.5 * y)
				mesh.rotate(Vector3.RIGHT, PI * 0.5 * x)
				mesh.rotate(Vector3.FORWARD, PI * 0.5 * z)

				print(to, Quat(mesh.rotation) * from)
				if (to - Quat(mesh.rotation) * from).length() < 0.001:
					print("FOUND")
					return


#	var proj_to_y: Vector3 = to - (to.dot(Vector3.UP)) * Vector3.UP
#	var proj_from_y: Vector3 = from - (from.dot(Vector3.UP)) * Vector3.UP
#
#	mesh.rotate_y(proj_from_y.angle_to(proj_to_y))
#
#	var proj_to_x: Vector3 = to - (to.dot(Vector3.UP)) * Vector3.UP
#	var proj_from_x: Vector3 = from - (from.dot(Vector3.UP)) * Vector3.UP
#
#	mesh.rotate_x(proj_from_x.angle_to(proj_to_x))
#
#	var proj_to_z: Vector3 = to - (to.dot(Vector3.UP)) * Vector3.UP
#	var proj_from_z: Vector3 = from - (from.dot(Vector3.UP)) * Vector3.UP
#
#	mesh.rotate_z(proj_from_z.angle_to(proj_to_z))

func __rotate(mesh: MeshInstance) -> void:
	var to: Vector3 = face_direction.normalized()
	var from: Vector3 = __calc_from(mesh)

	for y in 4:
		for x in 4:
			for z in 4:
				mesh.rotation = Vector3.ZERO
				mesh.rotate(Vector3.UP, PI * 0.5 * y)
				mesh.rotate(Vector3.RIGHT, PI * 0.5 * x)
				mesh.rotate(Vector3.FORWARD, PI * 0.5 * z)

				if to == Quat(mesh.rotation) * from:
					return

func __calc_from(mesh) -> Vector3:
	var from: Vector3 = Vector3.ZERO

	for face in mesh.get_children():
		from += face.translation

	return from.normalized()
#	print("hit")
#	mesh.transform.basis.slerp(Basis(Quat(from).slerp(Quat(to), weight)), 1.0)
#	mesh.rotation = -mesh.rotation * randf() * 3.0
##	mesh.rotation = Quat(mesh.rotation.normalized()).slerp(Quat(from), 1.0).xform(mesh.rotation)
##	mesh.rotation =
#	print("to: %s" % to)
#	print("from: %s" % from)
#	print("mesh slerp from: %s" % mesh.rotation.slerp(from, 1.0))
#	print("before: %s" % mesh.rotation)
#	mesh.rotation = mesh.rotation.slerp(from, 1.0)
#	mesh.rotation = -from
#	mesh.rotation = mesh.rotation.slerp(to, 1.0)
#	print("after: %s" % mesh.rotation)

#	if to.y != from.y:
#		mesh.rotation = Vector3(0.0, to.y, 0.0) \
#			.normalized() \
#			.rotated(
#				Vector3.BACK,
#				Vector3(0.0, from.y, 0.0).angle_to(Vector3(0.0, to.y, 0.0))
#			)
#
#	if to.x != from.x:
#		mesh.rotation = Vector3(to.x, 0.0, 0.0) \
#			.normalized() \
#			.rotated(
#				Vector3.BACK,
#				Vector3(from.x, 0.0, 0.0).angle_to(Vector3(to.x, 0.0, 0.0))
#			)



func to_rigid_body() -> RigidBody:
	var rigid_body: RigidBody = RigidBody.new()
	rigid_body.mass = 10.0
	rigid_body.weight *= 5.0

	get_tree().current_scene.add_child(rigid_body)
	rigid_body.global_transform = global_transform
	rigid_body.look_at($"%cube".translation, Vector3.UP)

	var part_collider: CollisionShape = get_child(1)
	var collider_rotation = part_collider.global_rotation

	var part_mesh: MeshInstance = get_child(2)
	var mesh_rotation = part_mesh.global_rotation

	remove_child(part_collider)
	rigid_body.add_child(part_collider)
	part_collider.global_rotation = collider_rotation

	remove_child(part_mesh)
	rigid_body.add_child(part_mesh)
	part_mesh.global_rotation = mesh_rotation

	rigid_body.collision_mask |= 1 << 2
	rigid_body.collision_layer |= 1 << 2

	return rigid_body
