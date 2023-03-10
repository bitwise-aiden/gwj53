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

	centre.material_override = centre.get_active_material(0).duplicate()


# Public methods

func attach(from: PhysicsBody, rotation: float) -> void:
	if from is RigidBody:
		var part_collider: CollisionShape = from.get_child(0)
		var part_mesh: MeshInstance = from.get_child(1)

		from.remove_child(part_collider)
		add_child(part_collider)

		from.remove_child(part_mesh)
		add_child(part_mesh)

		part_collider.transform = Transform.IDENTITY
		part_mesh.transform = Transform.IDENTITY

		part_mesh.transform.basis = calculate_basis(part_mesh)
		part_mesh.rotate(face_direction, rotation)


func calculate_basis(mesh: MeshInstance) -> Basis:
	var original_transform: Transform = mesh.transform

	# Please don't look at this code :joy:
	var to: Vector3 = face_direction.normalized()
	var from: Vector3 = __calculate_facing(mesh)

	for y in 4:
		for x in 4:
			for z in 4:

				mesh.transform = Transform.IDENTITY

				mesh.rotate(Vector3.UP, PI * 0.5 * y)
				mesh.rotate(Vector3.RIGHT, PI * 0.5 * x)
				mesh.rotate(Vector3.FORWARD, PI * 0.5 * z)

				if (to - Quat(mesh.rotation) * from).length() < 0.001:
					var basis: Basis = mesh.transform.basis

					mesh.transform = original_transform
					return basis

	mesh.transform = original_transform
	return mesh.transform.basis


func to_rigid_body() -> RigidBody:
	var rigid_body: RigidBody = RigidBody.new()
	rigid_body.mass = 10.0
	rigid_body.weight *= 5.0

	get_tree().current_scene.add_child(rigid_body)
	rigid_body.global_transform = global_transform

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


# Private methods

func __calculate_facing(mesh: MeshInstance) -> Vector3:
	var from: Vector3 = Vector3.ZERO

	for face in mesh.get_children():
		from += face.translation

	return from.normalized()
