extends Node2D

func _on_join_button_up():
	net.join_server($t_name.text) #Join the server and give our name
