extends RichTextLabel


func _process(delta):
	get_node("../title").text = "PLAYER LIST: "+str(net.peer_list.size())+"/"+str(net.MAX_PLAYERS)
	text = ""
	for ID in net.peer_list:
		#          ID         Retrieve the name of the client
		text += str(ID) + " " + str(net.peer_list[ID].Name) +" "+str(net.peer_list[ID].Position)+"\n"
