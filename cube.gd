extends Spatial

# Private enums

enum __Face { Front = 0, Standing, Back, Top, Equator, Bottom, Left, Middle, Right, Max }
enum __Direction { CW = 90, CCW = -90, Max = 2}


# Private variables

onready var __faces: Dictionary = {
	__Face.Front:        $faces_container/face_front,
	__Face.Standing:     $faces_container/face_standing,
	__Face.Back:         $faces_container/face_back,
	__Face.Top:          $faces_container/face_top,
	__Face.Equator:      $faces_container/face_equator,
	__Face.Bottom:       $faces_container/face_bottom,
	__Face.Left:         $faces_container/face_left,
	__Face.Middle:       $faces_container/face_middle,
	__Face.Right:        $faces_container/face_right,
}

onready var __parts_container: Spatial = $parts_container
onready var __parts: Array = $parts_container.get_children()

var __rotating: bool = false


# Lifecycle methods

func _ready() -> void:
	assert(__parts.size() == 26)


func _physics_process(delta: float) -> void:
	if !__rotating && Input.is_key_pressed(KEY_ENTER):
		__rotate_face(randi() % __Face.Max, __Direction.CCW)


# Private methods

func __rotate_face(face_type: int, degree: int) -> void:
	__rotating = true

	var face: Face = __faces[face_type]

	var origin = face.translation
	var axis: Vector3 = face.translation.abs().normalized()
	if axis == Vector3.ZERO:
		match face_type:
			__Face.Standing:
				axis = Vector3.BACK
			__Face.Equator:
				axis = Vector3.UP
			__Face.Middle:
				axis = Vector3.LEFT

	var parts: Array = face.get_overlapping_bodies()
	if parts.empty():
		__rotating = false
		return

	var tween: SceneTreeTween = create_tween().set_parallel()

	for part in parts:
		var offset: Vector3 = part.translation - origin

		tween.tween_method(
			self,
			"__rotate_part",
			0.0,
			deg2rad(degree),
			0.15,
			[part, part.transform, offset, origin, axis]
		)

	tween.chain().tween_interval(0.01)

	yield(tween, "finished")
	__rotating = false


func __rotate_part(
	angle: float,
	part: Part,
	transform_orig: Transform,
	offset: Vector3,
	origin: Vector3,
	axis: Vector3
) -> void:
	part.translation = origin + offset.rotated(axis, angle)
	
	var transform_rot: Transform = transform_orig.rotated(axis, angle)
	var quat_rot: Quat = Quat(part.transform.basis).slerp(transform_rot.basis, 1.0)
	part.transform = Transform(quat_rot, part.transform.origin)
