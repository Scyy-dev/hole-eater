extends Area3D

signal on_fallable_exited(fallable: Fallable)

@export var group_name: String = "fallable"
		
func _on_body_exited(body: Node3D) -> void:
	if (body.is_in_group(Player.FALLABLE_GROUP_NAME)) and body is Fallable:
		on_fallable_exited.emit(body as Fallable)
		print("emit body exit")
