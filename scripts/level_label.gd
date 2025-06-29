extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Level: 1"

func _on_level_up(player: Player, _levels_gained: int) -> void:
	text = "Level: " + str(player.level)
