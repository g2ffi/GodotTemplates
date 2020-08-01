extends KinematicBody2D

const SPEED = 100
var motion = Vector2.ZERO
var isPeer = false
var peer = preload("res://src/actors/peer.tscn")

func _ready():
	for p in net.peer_list:
		_create_peer(p)
	
	if !isPeer:
		return
	
	self.global_position.x = rand_range(0,1280)
	self.global_position.y = rand_range(0,720)

func _physics_process(delta):
	if isPeer:
		return
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
	net.self_data.pos=self.global_position

func _create_peer(id):
	var instance = peer.instance()
	instance.PEER_DATA = net.peer_list[id]
	get_parent().call_deferred("add_child",instance)
