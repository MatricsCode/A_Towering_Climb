extends MultiplayerSpawner

@export var bird_scene : PackedScene

@export var spawn_position : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = spawn_bird
	
	if spawn_position == null:
		push_error("You didn't assing the positional node to the birdspawner called: ", name)
	
	var birds = randi_range(1, 3)
	
	for i in birds:
		spawn(1)

func spawn_bird(data):
	var bird = bird_scene.instantiate()
	bird.position.y = spawn_position.position.y
	bird.position.x = spawn_position.position.x
	return bird
