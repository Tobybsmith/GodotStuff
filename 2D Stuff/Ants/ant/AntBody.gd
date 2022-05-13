extends KinematicBody2D

var target
var turn_direction = 0
var velocity : Vector2 = Vector2.ZERO
var speed = 150
var rotation_limiter = 1
var pickup_range = 10

var target_manager

signal target_consumed

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_root().get_node("Root").get_node("Manager").get_node("Target");
	target_manager = get_tree().get_root().get_node("Root").get_node("Manager")
	connect("target_consumed", get_tree().get_root().get_node("Root"), "target_consumed")


func _physics_process(delta):
	#every frame the ant should look for the target
	var t_pos = target.global_position
	look_at(t_pos)
	velocity = Vector2(speed, 0).rotated(rotation)
	velocity = move_and_slide(velocity)
	
	#leave behind a pheromone trail leading away from nest
	#create nest
	#create pheromone types
	#hold food and return it instead of destroying it
	
	
	
	
	
	
	#detect target and destroy it
	if (global_position - t_pos).length() < pickup_range:
		target_manager.remove_target(target)
		target = get_nearest_target();
		emit_signal("target_consumed")

func get_nearest_target():
	var closest
	var closest_length = INF
	for t in target_manager.active_targets:
		if (self.global_position - t.global_position).length() < closest_length:
			closest = t
			closest_length = (self.global_position - t.global_position).length()
	return closest
