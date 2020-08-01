extends Node

const SERVER_IP = "91.158.164.55" #LOCAL HOST
const SERVER_PORT = 22422
const MAX_PLAYERS = 12

var net_fps = 24 #How often a second information is sent to the server
var net_timer = 0.0

var peer_list:Dictionary = {} #Collect others data
var isGameStarted:bool = false

var self_data = {"Name":"PROJonyZ","Position":Vector2(0,0)} #Send our data
var self_id

func _ready():
	#Connect all signals
	get_tree().connect("connected_to_server", self, "_on_connect")

func join_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

#METHODS
func _process(delta):
	if isGameStarted:
		#Calcultes if enough time is passed to send all the information
		net_timer+=delta
		if net_timer < 1.0/net_fps:
			return
		net_timer-=1.0/net_fps #Substract from the already gathered delta net_fps amount
		
		rpc_id(1,"send_user_data",self_id,self_data) #Sends whole dict from ln13


#REMOTES
remote func peer_connected(id,data):
	if id==self_id:
		return
	peer_list[id] = data

remote func update_peer_data(data):
	peer_list=data

remote func start_game():
	isGameStarted=true
	get_tree().change_scene("res://src/scenes/level.tscn")

remote func receive_peer_list(list):
	peer_list = list

#Signals
func _on_connect():
	self_id = get_tree().get_network_unique_id()
	rpc_id(1,"add_user_to_list",self_id,self_data)

func _exit_tree(): #Close networking on quit
	get_tree().network_peer = null
