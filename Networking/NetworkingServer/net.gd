extends Node

const SERVER_PORT = 22422
const MAX_PLAYERS = 12
onready var OUTPUT

var game_settings:Dictionary = {"started":false}
var player_list:Dictionary = {} #Collect others data

func _ready():
	#Connect all signals
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

func _input(event):
	if Input.is_action_just_pressed("ui_accept") and game_settings.started==false:
		game_settings.started=true
		rpc("start_game")

func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer

func _exit_tree(): #On exist close server
	get_tree().network_peer = null

#REMOTES
remote func register_player(id,data):
	rpc("player_connected",id,data)
	player_list[id] = data

remote func pos(id):
	OUTPUT.add_line(str(id)+"SENT HIS POS!")

remote func sent_data(id,data):
	player_list[id] = data

#Signals
func _player_connected(id):
	OUTPUT.add_line(str(id)+" JOINED!")

func _player_disconnected(id):
	OUTPUT.add_line(str(id)+" LEFT!")
	player_list.erase(id) # Erase player from info.
	if game_settings.size() == 0: #If everyone leaves
		game_settings.started=false

