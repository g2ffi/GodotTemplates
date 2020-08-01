extends Sprite

var ID = 0

func _physics_process(delta):
	self.global_position = net.peer_list[ID].Position
