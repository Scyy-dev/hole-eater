class_name GameLevel

extends Node3D

@export var player: Player
@export var ui_controller: WorldUIController
@export var fallable_controller: FallableController

func _ready() -> void:
	ui_controller.restart_level.connect(_on_restart_game_button_pressed)
	ui_controller.exit_to_menu.connect(_on_exit_to_menu_button_pressed)
	player.set_player_color(Game.player_colour)
	
func _on_restart_game_button_pressed() -> void:
	get_tree().reload_current_scene()
	
func _on_exit_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
