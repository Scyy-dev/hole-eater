@tool
extends EditorScript

@export var clear_colliders: bool = false
@export var name_prefix = "hole_collider_"
@export var offset_y: float = -1
@export var segment_count: int = 12
@export var radius: float = 1.0
@export var segment_width: float = 0.2
@export var segment_height: float = 0.1

func _run():
	print("Creating hidden hole colliders for player...")
	var node = get_scene()
	if node.name != "player":
		push_error("No 'CharacterBody3D' found in current scene!")
		return
		
	print("Removing previously generated nodes...")
	for child in node.get_children():
		if child is CollisionShape3D and name_prefix in child.name:
			node.remove_child(child)
			
	if clear_colliders:
		print("Skipping creating colliders as clear_colliders is true")
		return

	print("Adding nodes...")
	for i in range(segment_count):
		var angle = i * TAU / segment_count
		var x = radius * cos(angle)
		var z = radius * sin(angle)

		var shape = CylinderShape3D.new()
		shape.radius = segment_width
		shape.height = segment_height

		var collision = CollisionShape3D.new()
		collision.name = (name_prefix + "%d") % i
		collision.shape = shape

		# Position and rotate
		collision.transform.origin = Vector3(x, offset_y, z)
		collision.rotation.y = angle
		node.add_child(collision)
		collision.owner = node
	print("Nodes added!")
