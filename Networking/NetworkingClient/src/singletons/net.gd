extends Node

const SERVER_IP = "127.0.0.1" #LOCAL HOST
const SERVER_PORT = 22422
const MAX_PLAYERS = 12

var player_list:Dictionary = {} #Collect others data
var isGameStarted:bool = false

var self_data = {"Name":"NAME","Position":Vector2(0,0)} #Send our data
var self_id

func _ready():
	#Connect all signals
	get_tree().connect("connected_to_server", self, "_connected_ok")

func join_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

#METHODS
func _physics_process(delta):
	if isGameStarted:
		send_data()

func send_data():
	rpc_id(1,"sent_data",self_id,self_data)

#REMOTES
remote func player_connected(id,data):
	if id==self_id:
		return
	player_list[id] = data

remote func start_game():
	isGameStarted=true
	get_tree().change_scene("res://src/scenes/level.tscn")


#Signals

func _connected_ok():
	self_id = get_tree().get_network_unique_id()
	rpc_id(1,"register_player",self_id,self_data)

func _exit_tree(): #Close networking on quit
	get_tree().network_peer = null