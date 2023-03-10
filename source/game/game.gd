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
