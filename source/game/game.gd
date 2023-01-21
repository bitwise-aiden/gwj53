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
	if (
		event is InputEventKey ||
		event is InputEventMouseButton
	) && event.pressed:
		if __state_manager.is_state(StateIdle):
			Event.emit_signal("game_start")
		elif __state_manager.is_state(StateInspect):
			Event.emit_signal("game_ready")
		else:
			return

		Audio.play_effect(Audio.effect_start)

