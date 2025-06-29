extends Area3D

signal on_fallable_entered(fallable: Fallable)

func _physics_process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group(Player.FALLABLE_GROUP_NAME) and body is Fallable:
			on_fallable_entered.emit(body as Fallable)
