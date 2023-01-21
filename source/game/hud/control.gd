extends Label


# Public variables

export(String) var input: String


# Private variables

var __tween: Tween


# Lifecycle methods

func _ready() -> void:
	Event.connect("control_updating", self, "__stop_change")
	connect("mouse_entered", self, "set_indexed", ["modulate:a", 1.0])
	connect("mouse_exited", self, "set_indexed", ["modulate:a", 0.7])
	connect("gui_input", self, "__click")

	text = OS.get_scancode_string(Setting.get(input))
	modulate.a = 0.7

	__tween = Tween.new()
	__tween.repeat = true
	add_child(__tween)

	__tween.interpolate_method(
		self,
		"__blink_visibility",
		0.0,
		0.5,
		0.5
	)


func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.pressed && __tween.is_active():
		if Controls.has_control(event.scancode):
			modulate = Color("#ff7878")

			var tween: SceneTreeTween = create_tween()
			tween.tween_property(
				self,
				"modulate",
				Color.white,
				0.3
			)

			Audio.play_effect_ui(Audio.effect_issue)
		else:
			Setting.set(input, event.scancode)
			text = OS.get_scancode_string(event.scancode)

			__tween.stop_all()
			__tween.reset_all()

			modulate.a = 0.7

			Audio.play_effect_ui(Audio.effect_select)
	if event is InputEventMouseButton && event.pressed && __tween.is_active():
		__tween.stop_all()
		__tween.reset_all()

		modulate.a = 0.7


# Private methods

func __blink_visibility(value: float) -> void:
	visible = value < 0.4


func __click(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed:
		__tween.start()

		Event.emit_signal("control_updating", self)

		Audio.play_effect_ui(Audio.effect_start)


func __stop_change(other: Control) -> void:
	if other == self:
		return

	__tween.stop_all()
	__tween.reset_all()
