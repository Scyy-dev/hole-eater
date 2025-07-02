class_name Player

extends CharacterBody3D

signal on_xp_gained(amount: float, new_xp: float, next_level_xp_cost: float)
signal on_level_up(player: Player, levels_gained: int)

const FALLABLE_GROUP_NAME := "fallable"
const HIDDEN_COLLIDER_GROUP_NAME := "hidden_collider"
const COLLIDER_NAME_PREFIX := "hidden_collider_"

@export var speed := 5.0
@export var xp_req_base: float = 10
@export var xp_req_power_base: float = 2
@export var xp_req_power_exponent: float = 0.5
@export var level_scale_factor: float = 0.5
@export var level_base_scale: float = 1
@export var hidden_collider_height_ratio: float = 0.8
@export var grid_size_radius_ratio: float = sqrt(2)
@export var camera_angle: float = -15
@export var camera_position_angle: float = 30
@export var camera_radius_ratio: float = 4

@onready var hole_visual: MeshInstance3D = $hole_visual
@onready var outer_ring_visual: MeshInstance3D = $outer_ring_visual
@onready var fallable_collider_check: Area3D = $fallable_collider_check
@onready var fallable_score_check: Area3D = $fallable_score_check
@onready var fallable_above_hole_check: Area3D = $fallable_above_hole_check
@onready var camera: Camera3D = $camera

var level = 1
var xp = 0

func _ready() -> void:
	# Manually trigger redrawing visuals / colliders
	_on_level_up(self, 0)
	print("score check: ", fallable_score_check.get_children())

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	var collision := move_and_collide(velocity * delta)
	
	if collision:
		var collider = collision.get_collider()
		if collider is RigidBody3D:
			var impulse = velocity.normalized() * (collider.mass / 2)
			collider.apply_central_impulse(impulse)
	
func xp_cost_for_next_level() -> float:
	return xp_req_base * pow(xp_req_power_base, xp_req_power_exponent * level)
	
func get_radius() -> float:
	return level_base_scale + level * level_scale_factor
	
func scale_visuals() -> void:
	var radius = get_radius()
	
	# Inner black radius is 85% of the full circle
	hole_visual.mesh.top_radius = (radius * 0.95) - 0.2
	hole_visual.mesh.bottom_radius = (radius * 0.95) - 0.2
	
	# Outer Radius represents the full circle
	outer_ring_visual.mesh.top_radius = radius
	outer_ring_visual.mesh.bottom_radius = radius
	
func remove_colliders() -> void:
	for node in get_children():
		if node.is_in_group(HIDDEN_COLLIDER_GROUP_NAME):
			node.queue_free()
	if fallable_collider_check.get_child_count() > 0:
		for child in fallable_collider_check.get_children():
			child.queue_free()
	if fallable_score_check.get_child_count() > 0:
		for child in fallable_score_check.get_children():
			child.queue_free()
	if fallable_above_hole_check.get_child_count() > 0:
		for child in fallable_above_hole_check.get_children():
			child.queue_free()
	
func generate_colliders() -> void:
	var radius := get_radius()
	var grid_size := radius * grid_size_radius_ratio
	
	var hidden_collider_height = radius * hidden_collider_height_ratio
	var hidden_collider_offset = -0.5 * hidden_collider_height
	
	var small_box = BoxShape3D.new()
	small_box.size = Vector3(grid_size * 2, hidden_collider_height, grid_size)
	
	var long_box = BoxShape3D.new()
	long_box.size = Vector3(grid_size * 5, hidden_collider_height, grid_size * 2)
	
	# Small boxes
	var collider_1 = CollisionShape3D.new()
	collider_1.shape = small_box
	collider_1.add_to_group(HIDDEN_COLLIDER_GROUP_NAME)
	collider_1.transform.origin = Vector3(1.5 * grid_size, hidden_collider_offset, 0)
	add_child(collider_1)

	var collider_2 = CollisionShape3D.new()
	collider_2.shape = small_box
	collider_2.add_to_group(HIDDEN_COLLIDER_GROUP_NAME)
	collider_2.transform.origin = Vector3(-1.5 * grid_size, hidden_collider_offset, 0)
	add_child(collider_2)

	# Long boxes
	var collider_3 = CollisionShape3D.new()
	collider_3.shape = long_box
	collider_3.add_to_group(HIDDEN_COLLIDER_GROUP_NAME)
	collider_3.transform.origin = Vector3(0, hidden_collider_offset, 1.5 * grid_size)
	add_child(collider_3)

	var collider_4 = CollisionShape3D.new()
	collider_4.shape = long_box
	collider_4.add_to_group(HIDDEN_COLLIDER_GROUP_NAME)
	collider_4.transform.origin = Vector3(0, hidden_collider_offset, -1.5 * grid_size)
	add_child(collider_4)
	
func generate_collider_checks() -> void:
	var radius = get_radius()
	
	var collider_check_shape := CylinderShape3D.new()
	collider_check_shape.height = radius * 5
	collider_check_shape.radius = radius * 2
	
	var score_check_shape := CylinderShape3D.new()
	score_check_shape.height = 0.5
	score_check_shape.radius = radius * 2
	
	var above_hole_check_shape := CylinderShape3D.new()
	above_hole_check_shape.height = 1
	above_hole_check_shape.radius = radius * 0.7
	
	var collider_check = CollisionShape3D.new()
	collider_check.shape = collider_check_shape
	collider_check.transform.origin = Vector3(0, radius * 2.5, 0)
	
	var score_check = CollisionShape3D.new()
	score_check.shape = score_check_shape
	score_check.transform.origin = Vector3(0, -radius * 2, 0)
	
	var above_hole_check = CollisionShape3D.new()
	above_hole_check.shape = above_hole_check_shape
	above_hole_check.transform.origin = Vector3(0, 0.5, 0)
	
	fallable_collider_check.add_child(collider_check)
	fallable_score_check.add_child(score_check)
	fallable_above_hole_check.add_child(above_hole_check)
	
func scale_camera() -> void:
	# Camera Position
	var angle = deg_to_rad(camera_position_angle)
	var radius = get_radius()
	var camera_y = radius * camera_radius_ratio * sin(angle)
	var camera_z = radius * camera_radius_ratio * cos(angle)
	camera.transform.origin.y = camera_y
	camera.transform.origin.z = camera_z
	
	# Camera Rotation
	var camera_rotation = Vector3(deg_to_rad(camera_angle), 0, 0)
	camera.transform.basis = Basis.from_euler(camera_rotation)
	
func _on_level_up(_player: Player, _levels_gained: int) -> void:
	scale_visuals()
	remove_colliders()
	generate_colliders()
	generate_collider_checks()
	scale_camera()
			
func _on_fallable_collider_check_exited(fallable: Fallable) -> void:
	fallable.collision_layer = 1
	fallable.collision_mask = 1
	fallable.physics_material_override.friction = 1
	
func _on_fallable_above_hole_check(fallable: Fallable) -> void:
	fallable.collision_layer = 2
	fallable.collision_mask = 2
	fallable.physics_material_override.friction = 0
	fallable.apply_central_impulse(Vector3(0, -0.001, 0))
			
func set_player_color(color: Color) -> void:
	var material = outer_ring_visual.mesh.surface_get_material(0)
	material.albedo_color = color
	outer_ring_visual.mesh.surface_set_material(0, material)

func _on_fallable_score_check(fallable: Fallable) -> void:
	fallable.fallen = true
	xp += fallable.xp_given
	
	var xp_for_next_level = xp_cost_for_next_level() - xp
	print("XP: " + str(xp) + ", until next lvl: " + str(xp_for_next_level))
	
	# Check how many level-ups the fallable gives us
	var level_up_count = 0
	while (xp >= xp_cost_for_next_level()):
		xp -= xp_cost_for_next_level()
		level += 1
		level_up_count += 1
		print("Leveled up!")
		
	if level_up_count > 0:
		on_level_up.emit(self, level_up_count)
	
	on_xp_gained.emit(fallable.xp_given, xp, xp_cost_for_next_level())
	fallable.queue_free()
	
