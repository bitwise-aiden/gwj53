extends CollisionShape

enum Effect { Collide = 1, Max }


# Public variables

export(Array, AudioStreamOGGVorbis) var effects_collide = []


# Private variables

onready var __parent: PhysicsBody = get_parent()


# Lifecycle methods

func _ready() -> void:
	connect("tree_entered", self, "__update_listener")


# Private methods

func __play_collision(_body: PhysicsBody) -> void:
	if !effects_collide.empty():
		Audio.play_effect(
			effects_collide[randi() % effects_collide.size()]
		)


func __update_listener() -> void:
	if __parent.has_signal("body_entered") && __parent.is_connected("body_entered", self, "__play"):
		__parent.disconnect("body_entered", self, "__play")

	__parent = get_parent()

	if __parent.has_signal("body_entered"):
		__parent.contact_monitor = true
		__parent.contacts_reported = 1
		__parent.connect("body_entered", self, "__play_collision")


