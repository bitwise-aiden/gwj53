class_name Cube extends Spatial


# Public enums

enum FaceType { Front = 0, Standing, Back, Top, Equator, Bottom, Left, Middle, Right, Max }
enum Direction { CW = 90, CCW = -90, Max = 2}


# Public variables

export(Array, AudioStreamOGGVorbis) var effects_rotation: Array = []

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

var __centres: Array = []
var __initial_transforms: Array = []
var __rotating: bool = false
var __tween: Tween


# Lifecycle methods

func _ready() -> void:
	for part in parts:
		var centre = part.get_child(0)
		centre.scale = Vector3.ZERO
		__centres.append(centre)

		__initial_transforms.append(part.transform)

	__tween = Tween.new()
	add_child(__tween)


# Public methods

func is_complete() -> bool:
	var directions: Dictionary = {}

	for part in parts:
		for face in part.mesh.get_children():
			var direction: Vector3 = face.global_translation - face.get_parent().global_translation
			if (directions.get(face.name, direction) - direction).length() > 0.001:
				return false

			directions[face.name] = direction

	return true


func rotate_face(face_type: int, degree: int) -> void:
	if __rotating:
		return

	__rotating = true

	if !effects_rotation.empty():
		Audio.play_effect(
			effects_rotation[randi() % effects_rotation.size()]
		)

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
			0.25,
			[part, part.transform, offset, origin, axis]
		)

	yield(tween, "finished")
	yield(get_tree(), "idle_frame")

	__rotating = false


func reset_parts() -> void:
	for i in parts.size():
		parts[i].transform = __initial_transforms[i]


func show_guide(show: bool, duration: float = 0.5, delay: float = 0.0) -> void:
	if delay:
		yield(get_tree().create_timer(delay), "timeout")

	var scale_dest: Vector3 = Vector3.ONE if show else Vector3.ZERO

	for centre in __centres:
		__tween.remove(centre, "scale")

		__tween.interpolate_property(
			centre,
			"scale",
			centre.scale,
			scale_dest,
			duration
		)

	__tween.start()


func show_partial_guide(face_count: int, duration: float = 0.2) -> void:
	for part in parts:
		var scale_dest: Vector3 = Vector3.ONE if part.face_count == face_count else Vector3.ZERO

		__tween.remove(part.centre, "scale")
		__tween.interpolate_property(
			part.centre,
			"scale",
			part.centre.scale,
			scale_dest,
			duration
		)

	__tween.start()


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
