extends RichTextLabel

func _ready():
	net.connect("c_add_line",self,"add_line")

func add_line(message:String):
	text += message+"\n"
	print(message)
