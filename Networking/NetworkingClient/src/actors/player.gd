extends KinematicBody2D

const SPEED = 100
var motion = Vector2.ZERO
var peer = preload("res://src/actors/peer.tscn")
func _ready():
	#Create peer for every ID from the list
	for p in net.peer_list:
		_create_peer(p)
	
	#Randomize our position
	randomize()
	self.global_position.x = rand_range(0,1280)
	self.global_position.y = rand_range(0,720)

func _physics_process(delta):
	#Movement
	var RIGHT = int(Input.is_action_pressed("ui_right"))
	var LEFT = int(Input.is_action_pressed("ui_left"))
	var UP = int(Input.is_action_pressed("ui_up"))
	var DOWN = int(Input.is_action_pressed("ui_down"))
	
	motion.x = RIGHT-LEFT
	motion.y = DOWN-UP
	motion = motion.normalized() * SPEED
	
	motion = move_and_slide(motion)
	
	#Update my position to self_data
	net.self_data.pos=self.global_position

func _create_peer(id):
	var instance = peer.instance()
	if net.peer_list[id] == null:
		return
	instance.peer_data = net.peer_list[id]
	get_parent().call_deferred("add_child",instance)
