extends TextureRect


# Private variables

var __tween: Tween

var __origin: float
var __destination: float


# Lifecycle methods

func _ready() -> void:
	Event.connect("cube_exploded", self, "__show", [true])
	connect("mouse_entered", self, "set_indexed", ["modulate:a", 1.0])
	connect("mouse_exited", self, "set_indexed", ["modulate:a", 0.7])
	connect("gui_input", self, "__click")

	modulate.a = 0.7
	__destination = rect_position.y
	rect_position.y -= 250.0
	__origin = rect_position.y

	__tween = Tween.new()
	add_child(__tween)


# Private methods

func __click(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed:
		Event.emit_signal("game_restart")
		__show(false)


func __show(value: bool) -> void:
	__tween.remove(self, "rect_position:y")
	__tween.interpolate_property(
		self,
		"rect_position:y",
		rect_position.y,
		__destination if value else __origin,
		Globals.TIME_START_TRANSITION
	)
	__tween.start()
