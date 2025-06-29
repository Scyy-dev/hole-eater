extends ProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# TODO - lerp the XP gained so it's not instant
	pass

func _on_xp_gained(_amount: float, new_xp: float, next_level_xp_cost: float) -> void:
	value = (new_xp / next_level_xp_cost) * 100
