class_name StateInspect extends State


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	var _result = Event.connect("game_ready", self, "set", ["_completed", true])

