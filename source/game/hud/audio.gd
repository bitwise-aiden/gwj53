extends TextureRect

# Public variables

export(Array, Texture) var textures: Array = []


# Private variables

var __over: bool = false setget __set_over


# Lifecycle methods

func _ready() -> void:
	connect("mouse_entered", self, "set", ["__over", true])
	connect("mouse_exited", self, "set", ["__over", false])
	connect("gui_input", self, "__click")

	texture = textures[min(textures.size() - 1, Setting.audio_volume)]
	modulate.a = 0.7


# Private methods

func __click(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed:
		Setting.audio_volume = (Setting.audio_volume + 1) % textures.size()
		texture = textures[Setting.audio_volume]

		Audio.play_effect_ui(Audio.effect_select)


func __set_over(value: bool) -> void:
	__over = value

	modulate.a = 1.0 if __over else 0.7
