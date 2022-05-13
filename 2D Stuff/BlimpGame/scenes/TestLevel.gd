extends Node2D

var t = 0
var mouse_pos_iso = Vector2.ZERO
var ground
var sky
# Called when the node enters the scene tree for the first time.
func _ready():
	ground = get_node("Ground")
	sky = get_node("Sky")

func _physics_process(delta):
	if (t % 120 == 0):
		mouse_pos_iso = sky.world_to_map(get_global_mouse_position());
		#returns -1 for empty cell
		print(mouse_pos_iso);
		print(sky.get_cellv(mouse_pos_iso))
		if(sky.get_cellv(mouse_pos_iso) == 1):
			sky.set_cellv(mouse_pos_iso, 0)
			pass
	t += 1
