extends RichTextLabel

func _ready():
	net.OUTPUT = self
	net.create_server()
	add_line("TEST SERVER STARTED")
	add_line("PORT: "+str(net.SERVER_PORT))
	add_line("MAX_PLAYERS :"+str(net.MAX_PLAYERS))

func add_line(message:String):
	var wholeOutput = text
	text = wholeOutput+message+"\n"
