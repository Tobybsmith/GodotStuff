extends Node2D

var world
var target
var target_node
var active_targets : Array

var holding_target = false

func _ready():
	randomize()
	world = get_parent()
	target = load("res://target/Target.tscn")

func add_target():
	var vsx : int = get_viewport().size.x
	var vsy : int = get_viewport().size.y
	target_node = target.instance()
	target_node.global_position = Vector2(randi()%vsx, randi()%vsy)
	#use a group here i think
	target_node.add_to_group("targets")
	self.add_child(target_node)
	active_targets.push_back(target_node)

func remove_target(target_to_remove):
	active_targets.erase(target_to_remove)
	target_to_remove.queue_free()
	replace_target()

func replace_target():
	var vsx : int = get_viewport().size.x
	var vsy : int = get_viewport().size.y
	target_node = target.instance()
	target_node.global_position = Vector2(randi()%vsx, randi()%vsy)
	#use a group here i think
	target_node.add_to_group("targets")
	self.add_child(target_node)
	active_targets.push_back(target_node)
