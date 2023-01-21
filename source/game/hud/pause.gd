extends TextureRect

# Public variables

export(Array, Texture) var textures: Array = []


# Lifecycle methods

func _ready() -> void:
	connect("mouse_entered", self, "set_indexed", ["modulate:a", 1.0])
	connect("mouse_exited", self, "set_indexed", ["modulate:a", 0.7])
	connect("gui_input", self, "__click")

	modulate.a = 0.7


# Private methods

func __click(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed:
		pass

