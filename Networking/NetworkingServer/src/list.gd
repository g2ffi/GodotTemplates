extends ColorRect

func _ready():
	net.connect("c_update_playerlist",self,"update_playerlist")

func update_playerlist(peer_list:Dictionary):
	#Prints Player list on the right with all the information from peer_list
	
	$title.text = "PLAYER LIST: "+str(peer_list.size())+"/"+str(net.MAX_PLAYERS) #E.G "PLAYER LIST: 0/12"
	$list.text = "" #Clear list
	for ID in peer_list: #For every peer in the list
		var PEER_DATA:Dictionary = peer_list[ID] #One peer's data from the list                  (ID) (NAME)  (POS)
		$list.text += str(ID) + " " + str(PEER_DATA.name) + " " + str(PEER_DATA.pos)+"\n" #E.G 1238845 Steve (20,30)
