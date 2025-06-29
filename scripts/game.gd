class_name GameWorld

extends Node3D

@onready var menu_ui: Control = $ui/menu_ui
@onready var world_ui: Control = $ui/world_ui
@onready var player: Player = $player

var menu_open: bool = false

signal game_world_ready(world: GameWorld)

var total_xp_in_world: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide the relevant UI
	render_ui()
	
	# Determine the total number of Fallables we track
	for node in get_all_children(self):
		if node is Fallable:
			var fallable = node as Fallable
			total_xp_in_world += fallable.xp_given
			
	game_world_ready.emit(self)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_menu"):
		menu_open = !menu_open
		render_ui()
		
func _on_restart_game_button_pressed() -> void:
	get_tree().reload_current_scene()
	
func _on_pick_colour_button_color_changed(color: Color) -> void:
	player.set_player_color(color)
	
func render_ui() -> void:
	menu_ui.visible = menu_open
	world_ui.visible = !menu_open
	
func get_all_children(node: Node) -> Array:
	var nodes: Array = []
	for child in node.get_children():
		nodes.append(child)
		var child_nodes = get_all_children(child)
		nodes.append_array(child_nodes)
	return nodes
