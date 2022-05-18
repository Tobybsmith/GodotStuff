tool

extends Node2D

export var width : int = 10
export var height : int = 5
const tower_width = 100
var tower_scene = load('res://Tower.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(width):
		var tower = tower_scene.instance()
		tower.res = height
		self.add_child(tower)
		tower.position = Vector2(i * tower_width, 0)
