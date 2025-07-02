extends Control

@onready var level_cbd_button: Button = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/level_cbd_button
@onready var exit_game_button: Button = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/exit_game_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_cbd_button.pressed.connect(func(): _pick_level("res://scenes/level_cbd.tscn"))
	exit_game_button.pressed.connect(_exit_game)
	
	# Preload the first level
	preload("res://scenes/level_cbd.tscn")

func _pick_level(level_name: String) -> void:
	get_tree().change_scene_to_file(level_name)

func _exit_game() -> void:
	get_tree().quit()
