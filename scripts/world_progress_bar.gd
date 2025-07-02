extends ProgressBar

var controller: FallableController = null
var current_xp = 0

func _on_controller_ready(fallable_controller: FallableController) -> void:
	controller = fallable_controller

func _on_player_xp_gained(amount: float, _new_xp: float, _next_level_xp_cost: float) -> void:
	current_xp += amount
	value = (current_xp / controller.total_world_xp) * 100
