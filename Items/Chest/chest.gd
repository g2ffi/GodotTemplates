extends Area2D

export(Resource) var drop #Insert a node to be as a drop (TSCN)
export(bool) var hasRandAngle = true #If true the dropped item will have a random angle

func _ready() -> void: #(->) you can specify what the function returns, (void) means null/nothing, but you can also use (int,float,bool,etc)
	randomize() #Get different outcomes from rands
	$sprite.frame = 0 #Set the frame as closed

func open() -> void: #Use the open function open the chest
	if drop==null: #If forgot to add a drop this will go off
		print("no drop was specified, please add a drop to the chest.")
		return
	if $sprite.frame == 1:
		print("chest is already opened")
		return
	$sprite.frame = 1 #Set the frame as opened
	var instance = drop.instance() #instance the node so it can be placed to the scene
	if hasRandAngle: #Randomize drop item's rot
		instance.rotation_degrees = randi()%360
	call_deferred("add_child",instance) #Add the item as a child of the chest

func _physics_process(delta) -> void:
	for body in get_overlapping_bodies(): #Get all bodies hitting the chest, loop through them.
		if body.name == "Player" and Input.is_action_just_pressed("ui_accept"): #If one of them is named "Player" and player hits the "ui_accept" action
			open() #open the chest.

