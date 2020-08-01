extends Node2D

func _on_join_button_up():
	net.join_server($b_name.text)
