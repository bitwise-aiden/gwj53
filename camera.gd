extends Camera


# Lifecycle methods

func _ready():
	look_at(Vector3(0.0, -3.0, 0.0), Vector3.UP)
