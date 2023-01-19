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
