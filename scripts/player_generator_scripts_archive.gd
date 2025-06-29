extends Node

#for z_mult in [1, -1]:
		#for x_mult in [1, -1]:
			#for i in range(hidden_collider_cylinder_sides / 4):
				#var points: Array = []
				#for y in [0, -0.5]:
					#var angle_1 = deg_to_rad(i * 360 / sides)
					#var angle_2 = deg_to_rad((i + 1) * 360 / sides)
					#
					#var p1 := Vector3(
						#radius * cos(angle_1) * x_mult,
						#y,
						#radius * sin(angle_1) * z_mult
					#)
					#
					#var p2 := Vector3(
						#radius * cos(angle_2) * x_mult,
						#y,
						#radius * sin(angle_2) * z_mult
					#)
					#
					#var p3 := Vector3(
						#collider_size * cos(angle_1) * x_mult,
						#y,
						#collider_size * sin(angle_1) * z_mult
					#)
					#
					#var p4 := Vector3(
						#collider_size * cos(angle_2) * x_mult,
						#y,
						#collider_size * sin(angle_2) * z_mult
					#)
					#
					#points.append_array([p1, p2, p3, p4])
				#
				#var mesh_shape := ConvexPolygonShape3D.new()
				#mesh_shape.points = points
				#
				#var mesh = CollisionShape3D.new()
				#mesh.shape = mesh_shape
				#mesh.add_to_group(HIDDEN_COLLIDER_GROUP_NAME)
				#add_child(mesh)
