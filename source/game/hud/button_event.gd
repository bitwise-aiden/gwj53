extends Button


# Public variables

export var event: String


# Lifecycle methods

func _init() -> void:
	connect("pressed", Event, "emit_signal", [event])
