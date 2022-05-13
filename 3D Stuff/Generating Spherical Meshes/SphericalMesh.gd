tool

extends MeshInstance

class_name Sphere

export var normal : Vector3

#need to create 2 vars, lat_lines and lon_lines that specify the lat and lon maxes
#then iterate across every lat-lon pair and make a vertex and the point
#doing sphere stuff to make one spherical mesh
#this will also make the planet stuff easier since we can just 
#read lat and lon from planet and translate into lat and lon of a map texture
#ok so this is the goal
#and to follow a new mesh making tutorial.

func regenerate_mesh():
	#we need an array of arrays
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	
	var vertex_array := PoolVector3Array()
	var uv_array := PoolVector2Array()
	var normal_array := PoolVector3Array()
	var index_array := PoolIntArray()
	
	var resolution : int = 20
	var num_verticies : int = resolution * resolution
	var num_indicies : int = (resolution - 1) * (resolution - 1) * 6
	
	var max_ele = PI
	var max_rot = 2*PI
	
	normal_array.resize(num_verticies)
	vertex_array.resize(num_verticies)
	uv_array.resize(num_verticies)
	index_array.resize(num_indicies)
	
	#index of current triangle
	#actually learn how this stuff works and what it means.
	var tri_index : int = 0
	var ele : float = 0
	var rot : float = 0
	var rad : float = 1.0
	var i = 0
	#need to make sure that the range is between 0 and resolution
	for lon in range(resolution):
		for lat in range(resolution):
			#make sure to vary the 
			var long = (lon / resolution) * max_ele
			var lati = (lat/resolution) * max_rot
			ele = (long / max_ele) * resolution
			rot = (lati / max_rot) * resolution
			var point : Vector3 = Vector3(0,0,0)
			point.x = rad * sin(ele) * cos(rot)
			point.y = rad * sin(ele) * sin(rot)
			point.z = rad * cos(ele)
			#turns the cube into a sphere
			#add the height from the noisemap to the rad to make local height changes
			var point_on_sphere = point
			vertex_array[i] = point_on_sphere
			i += 1
			if lon != (resolution - 1) and lat != (resolution - 1):
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
	for a in range(normal_array.size()):
		normal_array[a] = normal_array[a].normalized()
	
	arrays[Mesh.ARRAY_VERTEX] = vertex_array
	arrays[Mesh.ARRAY_NORMAL] = normal_array
	arrays[Mesh.ARRAY_INDEX] = index_array
	arrays[Mesh.ARRAY_TEX_UV] = uv_array
	
	call_deferred("_update_mesh", arrays)


func _update_mesh(arrays : Array):
	var _mesh := ArrayMesh.new()
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	self.mesh = _mesh

#more even vertext distribution that normalized()
func cube_to_sphere(point : Vector3) -> Vector3:
	var x2 : float = point.x * point.x
	var y2 : float = point.y * point.y
	var z2 : float = point.z * point.z
	var x : float = point.x * sqrt(1 - (y2 + z2) / 2 + (y2 * z2) / 3)
	var y : float = point.y * sqrt(1 - (z2 + x2) / 2 + (x2 * z2) / 3)
	var z : float = point.z * sqrt(1 - (x2 + y2) / 2 + (x2 * y2) / 3)
	return Vector3(x, y, z).normalized()

##this right here is bad!
##should map point between [(0,0), (1,1)] from the unit sphere
#func point_to_coord(point : Vector3) -> Vector2:
#	#the y value actually works!
#	#kinda
#	#doesnt work enough
#	var y = (1/PI) * acos(point.y)
#	var x = acos(point.x)/(2*PI)
#	return Vector2(x,y) 
