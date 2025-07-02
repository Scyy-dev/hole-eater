extends Control
class_name WorldUIController

signal restart_level
signal exit_to_menu

@export var player: Player
@export var fallable_controller: FallableController

@onready var player_ui: Control = $player_ui
@onready var menu_ui: Control = $menu_ui

@onready var xp_bar: ProgressBar = %xp_bar
@onready var level_label: Label = %level_label
@onready var world_progress_bar: ProgressBar = %world_progress_bar

@onready var restart_level_button: Button = %restart_level_button
@onready var exit_to_menu_button: Button = %exit_to_menu_button
@onready var pick_colour_button: ColorPickerButton = %pick_colour_button

var current_xp = 0

func _ready() -> void:
	player.on_xp_gained.connect(_on_xp_gained)
	player.on_level_up.connect(_on_level_up)
	
	restart_level_button.pressed.connect(_on_restart_level_button_pressed)
	exit_to_menu_button.pressed.connect(_on_exit_to_menu_button_pressed)
	
	player_ui.visible = true
	menu_ui.visible = false
	
	level_label.text = "Level 1"
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_menu"):
		player_ui.visible = !player_ui.visible
		menu_ui.visible = !menu_ui.visible
	
func _on_restart_level_button_pressed() -> void:
	restart_level.emit()
	
func _on_exit_to_menu_button_pressed() -> void:
	exit_to_menu.emit()
	
func _on_xp_gained(amount: float, new_xp: float, next_level_xp_cost: float) -> void:
	# TODO - lerp XP gained
	var xp_progress_ratio = (new_xp / next_level_xp_cost) * 100
	xp_bar.value = xp_progress_ratio
	
	current_xp += amount
	var world_progress_ratio = (current_xp / fallable_controller.total_world_xp) * 100
	world_progress_bar.value = world_progress_ratio
	
func _on_level_up(player: Player, _levels_gained: int) -> void:
	var text = "Level: " + str(player.level)
	level_label.text = text
	
