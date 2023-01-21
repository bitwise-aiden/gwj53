extends TextureRect

# Public variables

export(Texture) var pause: Texture
export(Texture) var close: Texture


# Private variables

onready var __menu: Control = $"../pause_menu"
onready var __menu_origin: Vector2 = __menu.rect_position

var __tween: Tween


# Lifecycle methods

func _ready() -> void:
	Event.connect("game_start", self, "__start")
	connect("mouse_entered", self, "set_indexed", ["modulate:a", 1.0])
	connect("mouse_exited", self, "set_indexed", ["modulate:a", 0.7])
	connect("gui_input", self, "__click")

	modulate.a = 0.7

	__menu.rect_position.y -= 1000.0

	rect_position.y -= 250.0

	__tween = Tween.new()
	add_child(__tween)


# Public method

func pause() -> void:
	if texture == pause:
		__tween.remove(__menu, "rect_position")
		__tween.interpolate_property(
			__menu,
			"rect_position",
			__menu.rect_position,
			__menu_origin,
			0.5
		)

		__tween.start()

		Event.emit_signal("game_pause", true)

		texture = close
		get_tree().paused = true

	else:
		__tween.remove(__menu, "rect_position")
		__tween.interpolate_property(
			__menu,
			"rect_position",
			__menu.rect_position,
			__menu_origin - Vector2(0.0, 1000.0),
			0.5
		)

		__tween.start()

		Event.emit_signal("game_pause", false)

		texture = pause
		get_tree().paused = false


# Private methods

func __click(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed:
		pause()



func __start() -> void:
	__tween.interpolate_property(
		self,
		"rect_position:y",
		rect_position.y,
		rect_position.y + 250.0,
		Globals.TIME_START_TRANSITION
	)
	__tween.start()
