class_name GameWorld

extends Node3D

@export var player: Player
@export var ui_controller: WorldUIController

func _ready() -> void:
	ui_controller.restart_level.connect(_on_restart_game_button_pressed)
	ui_controller.exit_to_menu.connect(_on_exit_to_menu_button_pressed)
	ui_controller.player_color_picked.connect(_on_pick_colour_button_color_changed)
		
func _on_restart_game_button_pressed() -> void:
	get_tree().reload_current_scene()
	
func _on_exit_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_pick_colour_button_color_changed(color: Color) -> void:
	player.set_player_color(color)
	
