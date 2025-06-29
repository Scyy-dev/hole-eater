extends Area3D

signal on_fallable_entered(fallable: Fallable)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(Player.FALLABLE_GROUP_NAME) and body is Fallable:
		on_fallable_entered.emit(body as Fallable)
