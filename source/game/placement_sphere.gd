class_name PlacementSphere extends Area


# Lifecycle methods 

func _ready():
	var camera_position: Vector3 = get_viewport().get_camera().translation
	$collider_back.look_at(camera_position, Vector3.UP)

