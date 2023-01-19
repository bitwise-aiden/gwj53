class_name StateIdle extends State


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube).(tree, cube) -> void:
	var _result = Event.connect("game_start", self, "set", ["_completed", true])

