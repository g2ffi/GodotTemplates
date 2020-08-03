extends Sprite

#This node is created for every peer on the list from player.gd

var PEER_DATA:Dictionary

func _physics_process(delta):
	if net.peer_list[PEER_DATA.ID]==null: #If self.id doesn't match one on the peer_list dictionary, delete
		queue_free()
	else:
		PEER_DATA=net.peer_list[PEER_DATA.ID]
	
	self.global_position = PEER_DATA.pos
