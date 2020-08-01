extends Resource
class_name peer_data

var ID:int
var name:String
var position:Vector2

func _init(aID:int = 0, aName:String = "", aPos:Vector2=Vector2.ZERO):
	ID = aID
	name = aName
	position = aPos
