extends Spatial


# Lifecycle method

func _ready() -> void:
	var original_transform: Transform = $mesh.global_transform

	look_at(Vector3.ZERO, Vector3.UP)

	$mesh.global_transform = original_transform
