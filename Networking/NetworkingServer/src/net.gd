extends Node

const SERVER_PORT = 22422
const MAX_PLAYERS = 12
onready var OUTPUT

var net_fps = 24 #How often a second information is sent to the server
var net_timer = 0.0

var game_settings:Dictionary = {"started":false}
var peer_list:Dictionary = {} #Collection of peer_data classes

func _ready():
	#Connect all signals
	get_tree().connect("network_peer_connected", self, "_on_peer_connect")
	get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnect")

func _input(event):
	#START GAME
	if Input.is_action_just_pressed("ui_accept") and game_settings.started==false:
		game_settings.started=true
		rpc("start_game")

func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer

func _process(delta):
	#if game_settings.started:
	#Calcultes if enough time is passed to send all the information
	net_timer+=delta
	if net_timer < 1.0/net_fps:
		return
	net_timer-=1.0/net_fps #Substract from the already gathered delta net_fps amount
	rpc("update_peers_list",peer_list) #Update all the peers lists

#REMOTES
remote func update_self_data(data:Dictionary): #Peer gave us his data
	peer_list[data.ID] = data

#Signals
func _on_peer_connect(id):
	OUTPUT.add_line(str(id)+" JOINED!")
	rpc_id(id,"update_peers_list",peer_list) #SEND
	if game_settings.started==true:
		rpc("start_game")

func _on_peer_disconnect(id):
	OUTPUT.add_line(str(id)+" LEFT!")
	peer_list.erase(id) # Erase player from info.
	if game_settings.size() == 0: #If everyone leaves
		game_settings.started=false

func _exit_tree(): #On exist close server
	get_tree().network_peer = null
