extends KinematicBody2D

const SPEED = 100
var motion = Vector2.ZERO

func _physics_process(delta):
	#Get Input as Ints
	var RIGHT = int(Input.is_action_pressed("ui_right"))
	var LEFT = int(Input.is_action_pressed("ui_left"))
	var UP = int(Input.is_action_pressed("ui_up"))
	var DOWN = int(Input.is_action_pressed("ui_down"))
	#SetDirs
	motion.x = RIGHT-LEFT
	motion.y = DOWN-UP
	motion = motion.normalized() * SPEED
	
	motion = move_and_slide(motion)
	
