extends Node


# Public signals

signal game_ready()
signal game_start()
signal game_finished()
signal game_restart()

signal time_changed(value)

signal cube_exploded()
signal cube_scrambled()

signal set_audio_volume(value)
signal set_control_cube_left(value)
signal set_control_cube_right(value)
signal set_control_cube_up(value)
signal set_control_cube_down(value)
signal set_control_part_left(value)
signal set_control_part_right(value)
signal set_score_finished(value)
signal set_score_unfinished(value)
