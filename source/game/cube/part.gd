class_name Part extends KinematicBody


# Public variables

onready var centre: MeshInstance = $centre
onready var face_count: int = $faces/mesh.get_child_count()
onready var faces: Spatial = $faces


var face_direction: Vector3 = Vector3.ZERO


# Lifecycle methods

func _ready() -> void:
	for face in faces.get_child(0).get_children():
		face_direction += face.translation

	face_direction.normalized()
