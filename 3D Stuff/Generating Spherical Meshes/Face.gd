tool

extends MeshInstance

class_name Face

export var normal : Vector3

func regenerate_mesh(planet_data : PlanetData):
	#we need an array of arrays
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	
	var vertex_array := PoolVector3Array()
	var uv_array := PoolVector2Array()
	var normal_array := PoolVector3Array()
	var index_array := PoolIntArray()
	
	var resolution : int = planet_data.resolution
	var num_verticies : int = resolution * resolution
	var num_indicies : int = (resolution - 1) * (resolution - 1) * 6
	
	normal_array.resize(num_verticies)
	vertex_array.resize(num_verticies)
	uv_array.resize(num_verticies)
	index_array.resize(num_indicies)
	
	#index of current triangle
	var tri_index : int = 0
	var axis_a := Vector3(normal.y, normal.z, normal.x)
	var axis_b : Vector3 = normal.cross(axis_a)
	for y in range(resolution):
		for x in range(resolution):
			var i : int = x + y * resolution
			var percent := Vector2(x,y) / (resolution - 1)
			var point_on_cube : Vector3 = normal + (percent.x-0.5) * 2.0 * axis_a + (percent.y - 0.5) * 2.0 * axis_b
			#turns the cube into a sphere
			#add the height from the noisemap to the rad to make local height changes
			var point_on_sphere = cube_to_sphere(point_on_cube)
			#do nothing (temp)
			#do UV stuff:
			var point_on_planet = planet_data.point_on_planet(point_on_sphere)
			var point_on_earth = planet_data.get_color_from_map(point_to_coord(point_on_planet))
			#i need a function to sample the image texture at a point and return the color value
			#vertex_array[i] = (point_on_earth * point_on_planet) + point_on_planet 
			vertex_array[i] = point_on_planet
			var l = point_on_planet.length()
			if l < planet_data.min_height:
				planet_data.min_height = l
			if l > planet_data.max_height:
				planet_data.max_height = l
			if x != (resolution - 1) and y != (resolution - 1):
				index_array[tri_index + 2] = i
				index_array[tri_index + 1] = i + resolution + 1
				index_array[tri_index] = i + resolution
				index_array[tri_index + 5] = i
				index_array[tri_index + 4] = i + 1
				index_array[tri_index + 3] = i + resolution + 1
				tri_index += 6
				
	#calculates normals
	for a in range(0, index_array.size(), 3):
		var b : int = a + 1
		var c : int = a + 2
		var ab : Vector3 = vertex_array[index_array[b]] - vertex_array[index_array[a]]
		var bc : Vector3 = vertex_array[index_array[c]] - vertex_array[index_array[b]]
		var ca : Vector3 = vertex_array[index_array[a]] - vertex_array[index_array[c]]
		var cross_ab_bc : Vector3 = ab.cross(bc) * -1.0
		var cross_bc_ca : Vector3 = bc.cross(ca) * -1.0
		var cross_ca_ab : Vector3 = ca.cross(ab) * -1.0
		normal_array[index_array[a]] += cross_ab_bc + cross_bc_ca + cross_ca_ab
		normal_array[index_array[b]] += cross_ab_bc + cross_bc_ca + cross_ca_ab
		normal_array[index_array[c]] += cross_ab_bc + cross_bc_ca + cross_ca_ab
	for i in range(normal_array.size()):
		normal_array[i] = normal_array[i].normalized()
	
	arrays[Mesh.ARRAY_VERTEX] = vertex_array
	arrays[Mesh.ARRAY_NORMAL] = normal_array
	arrays[Mesh.ARRAY_INDEX] = index_array
	arrays[Mesh.ARRAY_TEX_UV] = uv_array
	
	call_deferred("_update_mesh", arrays, planet_data)


func _update_mesh(arrays : Array, planet_data : PlanetData):
	var _mesh := ArrayMesh.new()
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	self.mesh = _mesh
	
	material_override.set_shader_param("min_height", planet_data.min_height)
	material_override.set_shader_param("max_height", planet_data.max_height)

#more even vertext distribution that normalized()
func cube_to_sphere(point : Vector3) -> Vector3:
	var x2 : float = point.x * point.x
	var y2 : float = point.y * point.y
	var z2 : float = point.z * point.z
	var x : float = point.x * sqrt(1 - (y2 + z2) / 2 + (y2 * z2) / 3)
	var y : float = point.y * sqrt(1 - (z2 + x2) / 2 + (x2 * z2) / 3)
	var z : float = point.z * sqrt(1 - (x2 + y2) / 2 + (x2 * y2) / 3)
	return Vector3(x, y, z).normalized()

#this right here is bad!
#should map point between [(0,0), (1,1)] from the unit sphere
func point_to_coord(point : Vector3) -> Vector2:
	#the y value actually works!
	#kinda
	#doesnt work enough
	var y = (1/PI) * acos(point.y)
	var x = acos(point.x)/(2*PI)
	return Vector2(x,y) 
