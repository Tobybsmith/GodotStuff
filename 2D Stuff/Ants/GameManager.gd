extends Node2D

var active_count = 10
var active_targets : Array

func _ready():
	#start by adding 10 targets
	for i in 10:
		get_node("Manager").add_target()

func target_consumed():
	print("UWU")
	get_node("Manager").add_target()
