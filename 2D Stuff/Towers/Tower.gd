tool

extends Node2D

export var res : int = 10
export var width : int = 1
var width_px = 100 * width
var height = res
var height_px = 50 * height
var dh = 50
var rects : Array
const TILES = ["std", "foundation", "mossy", "window_u", "window_d"]
const RULES = {"std" : ["std", "mossy", "window_d"], "foundation" : ["std", "foundation", "mossy"], "mossy":["std", "mossy", "window_d"], "window_d":["window_u"], "window_u":["std", "mossy"]}
#RULES determine which TILES can be above which
#everything starts as std

var rect = load("res://Rect.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_tower()
	render_tower()
	pass # Replace with function body.

#NOTES
#The first tile to generate should always be a foundation tile
#from there we let the randomness and the rules make a tower
#we need a way to generate legal possible tiles from the superposition
#and we always need to do the lowest tile first


func generate_tower():
	#now we need to create rules for tiles
	rects.resize(res)
	for n in range(rects.size()):
		#TOP LEFT OF RECT IS LOCAL 0,0
		#RECTS GO FROM 0,0 TO width_px,dh (100,50)
		#create a new rectangle with position at 
		rects[n] = rect.instance()
		self.add_child(rects[n])
		#rects[n].type = TILES[randi()%TILES.size()]
		var rules = get_rules(n)
		rects[n].type = rules[randi()%rules.size()]
		rects[n].position = Vector2(0, -n * dh)

func get_rules(pos_in_tower):
	#will return an array of the possible rect types that rect can be, then we pick one randomly
	#so all we do is just base it on the rect underneath
	if pos_in_tower == 0:
		return ["foundation"]
	else:
		var rules = RULES[rects[pos_in_tower - 1].type]
		if pos_in_tower == res - 1: #last pos, no cut off windows
			if rules.has("window_d"):
				rules.erase("window_d")
		return rules

func render_tower():
	for r in rects:
		r.render()
