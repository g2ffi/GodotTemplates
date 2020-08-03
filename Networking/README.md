# Godot Networking Templates

## Installation:
* Download both projects and get them running.
* Launch a server and few clients
* Click on the "join" button on all the clients (name not needed)
* You'll see clients joining in the server application "Lobby"
* Press "SPACE" while server.exe is focused and all the clients will be in a game together



## How it works: 
On client's net.gd is a dictionary which is sent to a server (self_data) and server puts in to a list (peer_list)
Server distributes this list to others

## SELF_DATA structure:
```gd
self_data = 
{
    ID:312312,
    name:"name",
    pos:"(0,0)",
}
```

## PEER_LIST structure:

peer_list is dictionary where all other peers data is stored in.

```gd
peer_list = 
{
    1245324={
        id:"again, i know"
        name:"name",
        pos:"(0,0)",
    }
    124123={
        id:124123
        name:"name",
        pos:"(0,0)",
    }
    453453={
        id:453453
        name:"name",
        pos:"(0,0)",
    }
}
```

## Usage: 
To add a new variable to be sent for example Animation

* Add new key to the SELF_DATA in client's net.gd
* Add animationplayer or animatedsprite to the peer.tscn
* Add code to the peer that retrieves the animation from the peer_list and plays it on the animationplayer
* peer.tscn has a one of a peer's data on it (peer_data)

## Example:
net.gd
Line 13 add an entry for the animation frame
```gd
var self_data = {"ID":0,
"name":"NAME",
"pos":Vector2(0,0),
"frame":0 #ADDED LINE
} 
```

player.gd
Update the frame
```gd
func _procces(delta):
    net.self_data[anim_frame] = $anim.frame
```

peer.gd
Update peer's frame from the dictionary, remember the self_data is always distributed
```gd
func _procces(delta):
    #AnimatedSprite
    $anim.frame = peer_data[anim_frame] #In practice you wouldn't send animation frames through net though
```

You don't have to touch the server's scripts to send variables around