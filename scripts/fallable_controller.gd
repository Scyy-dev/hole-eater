extends Node
class_name FallableController

var total_world_xp: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		if node is Fallable:
			total_world_xp += node.xp_given
