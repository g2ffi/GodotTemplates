extends Node

const SERVER_IP = "127.0.0.1" #LOCAL HOST
const SERVER_PORT = 22422
const MAX_PLAYERS = 12
const DEFAULT_NAME = "Steve" #If name is empty use this one

var isConnected = false
var net_fps = 1 #!PEER GETS THIS FROM THE SERVER! How often a second information is sent to the server
var net_timer = 0.0

var peer_list:Dictionary = {} #Collect others data
var self_data = {"ID":0,
"name":"NAME",
"pos":Vector2(0,0)
} #This is sent (net_fps) times a second to the server

func _ready():
	get_tree().connect("connected_to_server", self, "_on_server_connect")
	get_tree().connect("server_disconnected", self, "_on_server_disconnect")

#Call this to connect to a server w/User_name
func join_server(user_name:String):
	user_name = user_name.replace(" ","") #Delete spaces from our name
	self_data.name = user_name if user_name != "" else DEFAULT_NAME #If our name is empty use default one
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

#METHODS
func _process(delta):
	#if get_tree().network_peer == null: #If not connected to a server
	if !isConnected:
		return
	
	#Calcultes if enough time is passed to send all the information
	net_timer+=delta
	if net_timer < 1.0/net_fps:
		return
	net_timer-=1.0/net_fps
	
	rpc_unreliable_id(1,"update_self_data",self_data) #Sends whole dict from ln12

#REMOTES are called from an another peer or from a server
remote func update_peers_list(list:Dictionary): #Server updated our list
	list[self_data.ID]=null #Delete self from the list
	peer_list=list

remote func start_game():
	print("GameStarted")
	get_tree().change_scene("res://src/scenes/level.tscn")

remote func update_net_fps(a_net_fps): #Updates the "TickRate"
	net_fps = a_net_fps
	print("net_fps updated to ",a_net_fps)

#Signals
func _on_server_connect():
	print("Connected Successfully")
	isConnected = true
	
	#Give us a unique ID
	self_data.ID = get_tree().get_network_unique_id()

func _on_server_disconnect():
	print("Disconnected")
	#get_tree().change_scene("res://main.tscn")
	
	isConnected = false
	self_data.ID = null
	get_tree().network_peer = null

func _exit_tree(): #Close networking on quit
	get_tree().network_peer = null
