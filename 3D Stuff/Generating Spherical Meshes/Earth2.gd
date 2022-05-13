extends Spatial

func _ready():
	get_node("SphericalMesh").regenerate_mesh()
