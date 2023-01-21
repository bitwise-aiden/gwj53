extends MeshInstance


# Private variables

var __target_material: Material


# Lifecycle methods

func _ready() -> void:
	mesh = mesh.duplicate(true)
	__target_material = get_active_material(0).next_pass


# Public methods

func show_hover(show: bool = true) -> void:
	__target_material.set_shader_param("outline_width", 2.0 if show else 0.0)
