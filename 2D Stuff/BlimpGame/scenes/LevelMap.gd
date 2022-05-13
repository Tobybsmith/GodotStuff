extends TileMap



func _ready():
	pass # Replace with function body.

func coords(pos_to_convert):
	return world_to_map(pos_to_convert);
