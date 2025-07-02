extends Control

@onready var level_cbd_button: Button = %level_cbd_button
@onready var pick_colour_button: ColorPickerButton = %pick_colour_button
@onready var exit_game_button: Button = %exit_game_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_cbd_button.pressed.connect(func(): _pick_level("res://scenes/level_cbd.tscn"))
	pick_colour_button.color_changed.connect(_pick_colour)
	exit_game_button.pressed.connect(_exit_game)
	
	# Update the colour picker with the current player settings
	pick_colour_button.color = Game.player_colour

func _pick_level(level_name: String) -> void:
	get_tree().change_scene_to_file(level_name)
	
func _pick_colour(color: Color) -> void:
	Game.player_colour = color

func _exit_game() -> void:
	get_tree().quit()
