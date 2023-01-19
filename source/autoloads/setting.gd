extends Node

# Private constants

var __PATH: String = "settings"


# Public variables

var audio_volume: int = 4 setget __set_audio_volume
var control_cube_left: int = KEY_A setget __set_control_cube_left
var control_cube_right: int = KEY_D setget __set_control_cube_right
var control_cube_up: int = KEY_W setget __set_control_cube_up
var control_cube_down: int = KEY_S setget __set_control_cube_down
var control_part_left: int = KEY_Q setget __set_control_part_left
var control_part_right: int = KEY_E setget __set_control_part_right
var score_finished: float = 0.0 setget __set_score_finished
var score_unfinished: float =  0.0 setget __set_score_unfinished


# Lifecycle methods

func _ready() -> void:
	__load()


# Private variables

func __load() -> void:
	var file: File = File.new()

	if !file.file_exists("user://%s" % __PATH):
		__save()

	file.open("user://%s" % __PATH, File.READ)
	var content: String = Marshalls.base64_to_utf8(file.get_as_text())
	file.close()

	var input: PoolStringArray = content.split(";")

	self.audio_volume = int(input[0])
	self.control_cube_left = int(input[1])
	self.control_cube_right = int(input[2])
	self.control_cube_up = int(input[3])
	self.control_cube_down = int(input[4])
	self.control_part_left = int(input[5])
	self.control_part_right = int(input[6])
	self.score_finished = float(Marshalls.base64_to_utf8(input[7]))
	self.score_unfinished = float(Marshalls.base64_to_utf8(input[8]))


func __save() -> void:
	var output: PoolStringArray = [
		str(self.audio_volume),
		str(self.control_cube_left),
		str(self.control_cube_right),
		str(self.control_cube_up),
		str(self.control_cube_down),
		str(self.control_part_left),
		str(self.control_part_right),
		Marshalls.utf8_to_base64(str(score_finished)),
		Marshalls.utf8_to_base64(str(score_unfinished)),
	]

	var file: File = File.new()

	file.open("user://%s" % __PATH, File.WRITE)
	file.store_string(Marshalls.utf8_to_base64(";".join(output)))
	file.close()


func __set_audio_volume(value: int) -> void:
	audio_volume = value
	Event.emit_signal("set_audio_volume", value)

	__save()


func __set_control_cube_left(value: int) -> void:
	control_cube_left = value
	Event.emit_signal("set_control_cube_left", value)

	__save()


func __set_control_cube_right(value: int) -> void:
	control_cube_right = value
	Event.emit_signal("set_control_cube_right", value)

	__save()


func __set_control_cube_up(value: int) -> void:
	control_cube_up = value
	Event.emit_signal("set_control_cube_up", value)

	__save()


func __set_control_cube_down(value: int) -> void:
	control_cube_down = value
	Event.emit_signal("set_control_cube_down", value)

	__save()


func __set_control_part_left(value: int) -> void:
	control_part_left = value
	Event.emit_signal("set_control_part_left", value)

	__save()


func __set_control_part_right(value: int) -> void:
	control_part_right = value
	Event.emit_signal("set_control_part_right", value)

	__save()


func __set_score_finished(value: float) -> void:
	score_finished = value
	Event.emit_signal("set_score_finished", value)

	__save()


func __set_score_unfinished(value: float) -> void:
	score_unfinished = value
	Event.emit_signal("set_score_unfinished", value)

	__save()
