extends Sprite

var PEER_DATA:Dictionary

func _physics_process(delta):
	if net.peer_list[PEER_DATA.ID]==null:
		queue_free()
	else:
		PEER_DATA=net.peer_list[PEER_DATA.ID]
	self.global_position = PEER_DATA.pos
