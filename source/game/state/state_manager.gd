class_name StateManager extends Resource


# Private variables

var __cube: Cube
var __state: State
var __tree: SceneTree


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube) -> void:
	__cube = cube
	__state = StateIdle.new(tree, cube)
	__tree = tree

	Event.connect("game_restart", self, "__transition", [true])


# Lifecycle methods

func process(delta: float) -> void:
	__state.process(delta)

	if __state.is_complete():
		__transition()


func is_state(state_class) -> bool:
	return __state is state_class


# Private methods

func __transition(restart: bool = false) -> void:
	# Has to be above StateIdle, otherwise it will be consumed by StateIdle
	if __state is StateInspect:
		__state = StateExplode.new(__tree, __cube)

	elif __state is StateIdle:
		__state = StateScramble.new(__tree, __cube)

	elif __state is StateScramble:
		__state = StateInspect.new(__tree, __cube)

	elif __state is StateExplode:
		__state = StateAssemble.new(__tree, __cube)

	elif __state is StateAssemble:
		if restart:
			__state = StateReset.new(__tree, __cube)
		else:
			__state = StateComplete.new(__tree, __cube)

	elif __state is StateComplete:
		if !__cube.is_complete():
			__state = StateReset.new(__tree, __cube)
		else:
			__state = null
			__cube.reset_parts()
			__state = StateScramble.new(__tree, __cube)


	elif __state is StateReset:
		__state = StateScramble.new(__tree, __cube)
