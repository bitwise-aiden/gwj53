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

	face_direction.normalized()


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

