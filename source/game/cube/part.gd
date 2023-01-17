class_name Part extends KinematicBody


# Public variables

onready var face_count: int = $mesh.get_child_count()

var face_direction: Vector3

func _ready() -> void:
	var direction: Vector3 = Vector3.ZERO

	for face in $mesh.get_children():
		direction += face.translation - translation

	face_direction = direction.normalized()
	print(face_direction)
