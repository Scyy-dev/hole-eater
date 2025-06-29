extends ProgressBar

var total_world_xp: float = 0
var current_xp = 0

func _on_game_world_ready(world: GameWorld) -> void:
	total_world_xp = world.total_xp_in_world


func _on_player_xp_gained(amount: float, _new_xp: float, _next_level_xp_cost: float) -> void:
	current_xp += amount
	value = (current_xp / total_world_xp) * 100
