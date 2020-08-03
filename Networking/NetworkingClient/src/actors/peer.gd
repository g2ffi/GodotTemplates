extends Sprite

#This node is created for every peer on the list from player.gd

var peer_data:Dictionary

func _physics_process(delta):
	if net.peer_list[peer_data.ID]==null: #If self.id doesn't match one on the peer_list dictionary, delete
		queue_free()
	else:
		peer_data=net.peer_list[peer_data.ID]
	self.global_position = peer_data.pos
