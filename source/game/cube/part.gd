class_name Part extends KinematicBody


# Public variables

onready var centre: MeshInstance = $centre
onready var face_count: int = $mesh.get_child_count()
onready var mesh: MeshInstance = $mesh
