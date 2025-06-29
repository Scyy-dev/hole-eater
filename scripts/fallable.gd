class_name Fallable

extends RigidBody3D

const GROUP_NAME := "fallable"

@export var level_req: int = 1
@export var xp_given: int = 1

var fallen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group(GROUP_NAME)
	var physics_material = PhysicsMaterial.new()
	physics_material.friction = 1
	self.physics_material_override = physics_material
	self.mass = 0.01
