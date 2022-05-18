extends Node2D

var type = "std"
var spr

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func render():
	if type == "std":
		spr = load("res://Rect.png")
	elif type == "foundation":
		spr = load("res://Rect_Foundation.png")
	elif type == "mossy":
		spr = load("res://Rect_Mossy.png")
	elif type == "window_d":
		spr = load("res://Rect_Window.png")
	elif type == "window_u":
		spr = load("res://Rect_Window_Top.png")
	get_node("Sprite").texture = spr
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
