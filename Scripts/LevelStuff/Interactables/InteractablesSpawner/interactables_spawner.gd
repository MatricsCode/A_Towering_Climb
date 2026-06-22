extends MultiplayerSpawner

@export var interactables : Array[PackedScene]
@export var targets : Array[Node]
@export var positions : Array[Vector2]

func _ready():
	spawn_function = spawning
	
	set_multiplayer_authority(GlobalScript.peer_ID)
	
	for i in interactables.size():
		spawn(i)

func spawning(number):
	var child = null
	
	child = interactables.get(number).instantiate()
	child.target = targets[number]
	child.position = positions[number]
	
	return child
