extends Button


# Public variables

export var event_name: String


# Lifecycle methods

func _ready() -> void:
	assert(Event.has_signal(event_name))
	var _result = connect("pressed", Event, "emit_signal", [event_name])
