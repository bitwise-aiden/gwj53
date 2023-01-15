class_name StateAssemble extends State


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	pass


func process(delta: float) -> void:
	var mouse_position: Vector2 = _cube.get_viewport().get_mouse_position()
	var camera: Camera = _cube.get_viewport().get_camera()
	var space_state: PhysicsDirectSpaceState = _cube.get_world().direct_space_state

	var ray_origin: Vector3 = camera.project_ray_origin(mouse_position)
	var ray_dest: Vector3 = camera.project_ray_normal(mouse_position) * 20.0

	var result: Dictionary = space_state.intersect_ray(ray_origin, ray_dest, [], 1 << 3)
	if result.has("position"):
		var part: RigidBody = result["collider"]

#	var ray_cast: RayCast = RayCast.new()
#	camera.add_child(ray_cast)
#
#	ray_cast.set_collision_mask(1 << 3)
#	ray_cast.set_cast_to(ray_dest)
#
#	if ray_cast.is_colliding():
#		print("Hit cube")
#
#	camera.remove_child(ray_cast)
