extends Spatial


# Private variables

onready var __cube = $"%cube"

var __state_manager: StateManager


# Lifecycle methods

func _ready() -> void:
	randomize()

	__state_manager = StateManager.new(get_tree(), __cube)


func _physics_process(delta: float) -> void:
	__state_manager.process(delta)


func _input(event) -> void:
	print(event)
	if (
		event is InputEventKey ||
		event is InputEventMouseButton
	) && __state_manager.is_state(StateIdle):
		if event.pressed:
			Event.emit_signal("game_start")

