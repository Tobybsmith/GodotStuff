extends KinematicBody

var keypress = false
var rot = 0
var rot_vel = 0.0001
const ROT_DAMP = 0.001
const ROT_ACCEL = 0.0005
const MAX_ROT_VEL = 0.03
const MAX_VEL = 10
const ACCEL = 20
var vel = Vector3.ZERO

onready var mesh = $MeshInstance
#need to make player move along a sphere
#player only has contol of x and z axes - y gets controlled by sphere movement

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	#handles rotation of the player
	keypress = false
	if Input.is_action_pressed("left"):
		keypress = true
		rot_vel += ROT_ACCEL
	elif Input.is_action_pressed("right"):
		keypress = true
		rot_vel -= ROT_ACCEL
#	else:
#		rot_vel = 0
	#if the player holds one direction key and switches while holding, the damping doesn't apply
	if (rot_vel > 0 and not keypress):
		rot_vel -= ROT_DAMP
	elif (rot_vel < 0 and not keypress):
		rot_vel += ROT_DAMP
	#catches lingering tiny rotation
	if abs(rot_vel) < 0.0005:
		rot_vel = 0
	rot_vel = clamp(rot_vel, -MAX_ROT_VEL, MAX_ROT_VEL)
	
	rot = self.rotation.y
	if vel.length() < MAX_VEL:
		#dont do this, should split into x and z transforms instead of this
		vel += Vector3(sin(rot), 0, cos(rot)) * -ACCEL
	vel.normalized()
	rotate_y(rot_vel)
	move_and_slide(vel, Vector3.UP)
