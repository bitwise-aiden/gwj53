class_name StateExplode extends State 


# Lifecycle methods 

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	__explode()


# Protected methods 
func _handle_input(delta: float) -> void: 
	pass


# Private methods 

func __explode() -> void: 
	yield(__pulse(0.1, 0.1), "completed")
	yield(_tree.create_timer(1.0), "timeout")
	
	yield(__pulse(0.5, 0.1), "completed")
	yield(_tree.create_timer(1.0), "timeout")
	
	yield(__pulse(1.0, 0.1), "completed")
	yield(_tree.create_timer(1.0), "timeout")
	
	var origin: Vector3 = _cube.translation
	
	for part in _cube.parts:
		var part_copy: Part = part.duplicate()
		
		var rigid_body: RigidBody = RigidBody.new()
		rigid_body.transform = part_copy.transform
		
		_tree.current_scene.add_child(rigid_body)
		rigid_body.add_child(part_copy)
		
		var direction: Vector3 = rigid_body.translation - origin
		rigid_body.apply_impulse(rigid_body.translation, direction * 50.0)
		
		part.visible = false
	
	
	Event.emit_signal("cube_exploded")
	_completed = true


func __pulse(scalar: float, duration: float) -> void: 
	yield(__move(+scalar, duration), "completed")
	yield(__move(-scalar, duration), "completed")


func __move(scalar: float, duration: float) -> void:
	var origin: Vector3 = _cube.translation
	
	var tween: SceneTreeTween = _tree.create_tween().set_parallel().set_ease(Tween.EASE_OUT)
	
	for part in _cube.parts:
		var direction: Vector3 = (part.translation - origin).normalized()
		
		tween.tween_property(
			part, 
			"translation",
			part.translation + direction * scalar,
			duration
		)
	
	yield(tween, "finished")
