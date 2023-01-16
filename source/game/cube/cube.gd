class_name Cube extends Spatial

# Public enums

enum FaceType { Front = 0, Standing, Back, Top, Equator, Bottom, Left, Middle, Right, Max }
enum Direction { CW = 90, CCW = -90, Max = 2}


# Public variables

onready var parts: Array = $parts_container.get_children()

# Private variables

onready var __faces: Dictionary = {
	FaceType.Front:       $faces_container/face_front,
	FaceType.Standing:    $faces_container/face_standing,
	FaceType.Back:        $faces_container/face_back,
	FaceType.Top:         $faces_container/face_top,
	FaceType.Equator:     $faces_container/face_equator,
	FaceType.Bottom:      $faces_container/face_bottom,
	FaceType.Left:        $faces_container/face_left,
	FaceType.Middle:      $faces_container/face_middle,
	FaceType.Right:       $faces_container/face_right,
}

onready var __parts_container: Spatial = $parts_container

var __rotating: bool = false


# Public methods

func rotate_face(face_type: int, degree: int) -> void:
	if __rotating:
		return

	__rotating = true

	var face: Face = __faces[face_type]

	var origin = face.translation
	var axis: Vector3 = face.translation.abs().normalized()
	if axis == Vector3.ZERO:
		match face_type:
			FaceType.Standing:
				axis = Vector3.BACK
			FaceType.Equator:
				axis = Vector3.UP
			FaceType.Middle:
				axis = Vector3.LEFT

	var overlapping_parts: Array = face.get_overlapping_bodies()
	if overlapping_parts.empty():
		__rotating = false
		return

	var tween: SceneTreeTween = create_tween().set_parallel()

	for part in overlapping_parts:
		var offset: Vector3 = part.translation - origin

		var _result = tween.tween_method(
			self,
			"__rotate_part",
			0.0,
			deg2rad(degree),
			0.15,
			[part, part.transform, offset, origin, axis]
		)

	var _result = tween.chain().tween_interval(0.02)

	yield(tween, "finished")
	__rotating = false


# Private methods

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
