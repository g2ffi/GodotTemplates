extends Node

const SERVER_IP = "127.0.0.1" #LOCAL HOST
const SERVER_PORT = 22422
const MAX_PLAYERS = 12

var net_fps = 24 #How often a second information is sent to the server
var net_timer = 0.0

var peer_list:Dictionary = {} #Collect others data
var isGameStarted:bool = false

var self_data = {"name":"NAME","ID":0,"pos":Vector2(0,0)}#{"Name":"PROJonyZ","Position":Vector2(0,0)} #Send our data

func _ready():
	get_tree().connect("connected_to_server", self, "_on_connect")

func join_server(user_name:String):
	self_data.name = user_name if user_name != "" else "steve"
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

#METHODS
func _process(delta):
	if get_tree().network_peer == null:
		print("NULL")
		return
	print("NO NULL")
	#Calcultes if enough time is passed to send all the information
	net_timer+=delta
	if net_timer < 1.0/net_fps:
		return
	net_timer-=1.0/net_fps #Substract from the already gathered delta net_fps amount
	
	rpc_id(1,"update_self_data",self_data) #Sends whole dict from ln13

#REMOTES
remote func update_peers_list(list:Dictionary): #Update whole list from server
	list[self_data.ID]=null
	peer_list=list

remote func start_game():
	isGameStarted=true
	get_tree().change_scene("res://src/scenes/level.tscn")

#Signals
func _on_connect():
	self_data.ID = get_tree().get_network_unique_id()
	rpc_id(1,"update_self_data",self_data)

func _exit_tree(): #Close networking on quit
	get_tree().network_peer = null
