extends Node


# Lifecycle methods

func _ready():
	Event.connect("set_control_cube_left", self, "__update_control", ["cube_left"])
	Event.connect("set_control_cube_right", self, "__update_control", ["cube_right"])
	Event.connect("set_control_cube_up", self, "__update_control", ["cube_up"])
	Event.connect("set_control_cube_down", self, "__update_control", ["cube_down"])
	Event.connect("set_control_part_left", self, "__update_control", ["part_left"])
	Event.connect("set_control_part_right", self, "__update_control", ["part_right"])


# Private methods

func __update_control(value: int, action: String) -> void:
	InputMap.action_erase_events(action)

	var event: InputEventKey = InputEventKey.new()
	event.scancode = value

	InputMap.action_add_event(action, event)
