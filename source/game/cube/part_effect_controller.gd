extends CollisionShape

enum Effect { Collide = 1, Max }


# Private variables

onready var __parent: PhysicsBody = get_parent()
onready var __player_effect: AudioStreamPlayer3D = $effect

# Lifecycle methods

func _ready() -> void:
	connect("tree_entered", self, "__update_listener")


# Private methods

func __play_collision(_body: PhysicsBody) -> void:
	print("Hit")


func __update_listener() -> void:
	if __parent.has_signal("body_entered"):
		__parent.disconnect("body_entered", self, "__play")

	__parent = get_parent()

	if __parent.has_signal("body_entered"):
		__parent.contact_monitor = true
		__parent.contacts_reported = 1
		var result = __parent.connect("body_entered", self, "__play_collision")
		print("Connected %s" % result)


