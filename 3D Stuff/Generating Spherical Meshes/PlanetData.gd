tool

extends Resource

class_name PlanetData

export var radius := 1.0 setget set_radius
export var resolution := 1 setget set_res
export var amplitude : float = 1.0
export var noise : OpenSimplexNoise setget set_noise
export(StreamTexture) var img : StreamTexture
export var amp : float = 5.0

var min_height = 99999.9
var max_height = 0.0
var locked_and_loaded = false
var i

func set_radius(val):
	radius = val
	emit_signal("changed")

func set_res(val):
	resolution = val
	emit_signal("changed")

func set_noise(val):
	noise = val
	emit_signal("changed")
	if(noise != null and not noise.is_connected("changed", self, "on_data_changed")):
		noise.connect("changed", self, "on_data_changed")

func point_on_planet(point_on_sphere : Vector3) -> Vector3:
	#calculate new height
	return point_on_sphere

#problematic function fr fr
func get_color_from_map(coord: Vector2) -> float:
	if not locked_and_loaded:
		i = img.get_data()
		i.lock()
		locked_and_loaded = true
	#poolbytesarray and not image maybe 
	var coord_fixed = Vector2(coord.x * 2160, coord.y * 1080)
	return i.get_pixelv(coord_fixed).r

func on_data_changed():
	emit_signal("changed")
