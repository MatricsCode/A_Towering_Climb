extends MultiplayerSpawner

@export var bird_scene : PackedScene

@export var spawn_position : Vector2

@export var max_birds : int

@export var positional_change : int

var positions = []

var birds = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		spawn_function = spawn_bird
		
		if spawn_position == null:
			push_error("You didn't assing the positional node to the birdspawner called: ", name)
		
		birds = randi_range(3, max_birds)
		
		for i in birds:
			spawn(1)

func spawn_bird(data):
	var bird = bird_scene.instantiate()
	
	var bird_position = randf_range(spawn_position.x - positional_change, spawn_position.x + positional_change)
	
	var i = 0
	var itterations = 0
	while i < positions.size():
		itterations += 1
		if bird_position < positions[i] + 20 and bird_position > positions[i] - 20:
			bird_position = randf_range(spawn_position.x - positional_change, spawn_position.x + positional_change)
			i = 0
		else:
			i += 1
		
		if itterations > 50:
			bird_position = randf_range(spawn_position.x - positional_change, spawn_position.x + positional_change)
			birds = 0
	
	bird.positionY = spawn_position.y
	bird.position.x = randf_range(spawn_position.x - positional_change, spawn_position.x + positional_change)
	
	
	positions.append(bird.position.x)
	
	return bird
