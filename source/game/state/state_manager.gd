class_name StateManager extends Resource


# Private variables

var __cube: Cube
var __state: State
var __tree: SceneTree


# Lifecycle methods

func _init(tree: SceneTree, cube: Cube) -> void:
	__cube = cube
	__state = StateExplode.new(tree, cube)
	__tree = tree


# Lifecycle methods

func process(delta: float) -> void:
	__state.process(delta)

	if __state.is_complete():
		__transition()


# Private methods

func __transition() -> void:
	# Has to be above StateIdle, otherwise it will be consumed by StateIdle
	if __state is StateInspect:
		__state = StateExplode.new(__tree, __cube)

	elif __state is StateIdle:
		__state = StateScramble.new(__tree, __cube)

	elif __state is StateScramble:
		__state = StateInspect.new(__tree, __cube)

	elif __state is StateExplode:
		__state = StateAssemble.new(__tree, __cube)
