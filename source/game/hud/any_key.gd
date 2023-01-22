extends Label


# Private variables

var __tween: Tween

var __origin: Vector2
var __destination: Vector2


# Lifecycle methods

func _ready() -> void:
	Event.connect("game_start", self, "__show", [false])
	Event.connect("game_ready", self, "__show", [false])
	Event.connect("cube_scrambled", self, "__show", [true])
	connect("mouse_entered", self, "set_indexed", ["modulate:a", 1.0])
	connect("mouse_entered", self, "__mouse_enter", [true])
	connect("mouse_exited", self, "set_indexed", ["modulate:a", 0.7])
	connect("mouse_exited", self, "__mouse_enter", [false])
	connect("gui_input", self, "__click")

	modulate.a = 0.7

	__origin = rect_position
	__destination = rect_position + Vector2.DOWN * 250.0

	__tween = Tween.new()
	add_child(__tween)


# Private methods

func __click(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed:
		match text:
			"- Scramble -", "Scramble":
				Event.emit_signal("game_start")
			"- Ready -", "Ready":
				Event.emit_signal("game_ready")

		yield(__show(false), "completed")

		text = "Ready"


func __mouse_enter(hover: bool) -> void:
	match [text, hover]:
		["- Scramble -", false]:
			text = "Scramble"
		["Scramble", true]:
			text = "- Scramble -"
		["- Ready -", false]:
			text = "Ready"
		["Ready", true]:
			text = "- Ready -"



func __show(value: bool) -> void:
	print("Hellow")

	__tween.remove(self, "rect_position")
	__tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		__origin if value else __destination,
		0.2
	)
	__tween.start()

	yield(__tween, "tween_completed")
