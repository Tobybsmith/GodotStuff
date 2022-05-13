extends Node2D

var target
var turn_direction = 0
var velocity : Vector2 = Vector2.ZERO
var speed = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_root().get_node("Root").get_node("Target");


func _physics_process(delta):
	#every frame the ant should look for the target
	var t_pos = target.global_position
	#can use look at function to rotate towards something
	look_at(target)
	#simply move towards
	velocity = Vector2(speed, 0).rotated(rotation)
	pass
