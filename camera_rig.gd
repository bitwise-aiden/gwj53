extends Spatial


# Lifecycle methods

func _process(delta: float) -> void:
	rotate_y(delta * 0.2)
