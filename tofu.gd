extends MeshInstance3D

@export var visualizing_material: ShaderMaterial = preload("res://burnedness_material.tres")

var I: int = 11

var arrays : Array
var array_mesh : ArrayMesh
var vertices : PackedVector3Array
var normals : PackedVector3Array
var custom0 : PackedFloat32Array # Stores how "burned" each vertex is

func _init() -> void:
	arrays = mesh.surface_get_arrays(0)
	vertices = arrays[Mesh.ARRAY_VERTEX]
	normals = arrays[Mesh.ARRAY_NORMAL]
	
	# Create the array for custom channel index 0
	custom0 = PackedFloat32Array()
	custom0.resize(vertices.size())
	arrays[Mesh.ARRAY_CUSTOM0] = custom0
	
	array_mesh = ArrayMesh.new()
	update_mesh()
	mesh = array_mesh


func update_mesh() -> void:
	if array_mesh.get_surface_count() == 1:
		array_mesh.surface_remove(0)
	
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays, [], {},
		# Custom channel 0 is made of 32-bit float, one per vertex
		# R means that only the red channel is used in the shader,
		# hence len(custom0) = 1 * len(vertices)
		Mesh.ARRAY_CUSTOM_R_FLOAT << Mesh.ARRAY_FORMAT_CUSTOM0_SHIFT
		# iffy opengl optimization
		| Mesh.ARRAY_FLAG_USE_DYNAMIC_UPDATE)
	
	array_mesh.surface_set_material(0, visualizing_material)


func _process(delta: float) -> void:
	for i in vertices.size():
		var vert_pos := global_transform * vertices[i]
		var normal := global_basis * normals[i]
		
		vertices[i] += 0.2 * normals[i] * sin((i/float(vertices.size())+Time.get_ticks_msec()/1000.)*TAU) * delta
		
		var facing_ratio := normal.dot(Vector3.DOWN)
		var proximity_ratio := clampf(1.0 / (1.0 + vert_pos.y), 0, 1)
		
		custom0[i] += 1.0 * delta * (facing_ratio + proximity_ratio)
		
		#region debugdraw
		var debug_color := Color(normals[i].x, normals[i].y, normals[i].z).lerp(Color.BLACK, facing_ratio)
		DebugDraw3D.draw_arrow(vert_pos, vert_pos + (0.1+smoothstep(0.3, 0.6, proximity_ratio)) * normal, debug_color, 0.2, false)
		
		if i == I:
			DebugDraw3D.draw_sphere_xf(Transform3D(global_basis.scaled(0.2 * Vector3.ONE), vert_pos))
			DebugDraw2D.config.text_block_position = DebugDraw2DConfig.POSITION_LEFT_BOTTOM
			DebugDraw2D.begin_text_group("vertex[%d]" % I)
			DebugDraw2D.set_text("facing_ratio", facing_ratio)
			DebugDraw2D.set_text("proximity_ratio", proximity_ratio)
			DebugDraw2D.set_text("proximity_ratio_debug", smoothstep(0.2, 0.6, proximity_ratio))
			DebugDraw2D.set_text("1. +", (facing_ratio + proximity_ratio))
			DebugDraw2D.set_text("2. 🔥", custom0[i])
			DebugDraw2D.end_text_group()
		#endregion
	
	update_mesh()

	DebugDraw2D.config.text_block_position = DebugDraw2DConfig.POSITION_LEFT_TOP
	DebugDraw2D.set_text("FPS", Engine.get_frames_per_second())
