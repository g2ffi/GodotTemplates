extends Node

signal c_update_playerlist(list, m_players)
signal c_add_line(content) #Add a line to the console

const SERVER_PORT = 22422
const MAX_PLAYERS = 12

var net_fps = 24 #How often a second information is sent to the server
var net_timer = 0.0

var peer_list:Dictionary = {} #Collection of peer_data classes

func _ready():
	#Connect all signals
	get_tree().connect("network_peer_connected", self, "_on_peer_connect")
	get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnect")
	
	create_server()

func _process(delta):
	#Calcultes if enough time is passed to send all the information
	net_timer+=delta
	if net_timer < 1.0/net_fps:
		return
	net_timer-=1.0/net_fps #Substract from the already gathered delta net_fps amount
	
	rpc("update_peers_list",peer_list) #Update all the peers lists

func _input(event):
	#START GAME
	if Input.is_action_just_pressed("ui_accept"):
		add_line("GAME STARTED")
		rpc("start_game")

func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer

func add_line(content:String):
	emit_signal("c_add_line",content)

#REMOTES
remote func update_self_data(data:Dictionary): #Peer gave us his data
	peer_list[data.ID] = data #Add peers data to list, use id as key
	emit_signal("c_update_playerlist",peer_list) #Update list

#Signals
func _on_peer_connect(id):
	rpc_id(id,"update_net_fps",net_fps) #SEND
	add_line(str(id)+" JOINED!")

func _on_peer_disconnect(id):
	peer_list.erase(id) # Erase player from info.
	add_line(str(id)+" LEFT!")
	emit_signal("c_update_playerlist",peer_list) #Update list

func _exit_tree(): #On exist close server
	get_tree().network_peer = null
