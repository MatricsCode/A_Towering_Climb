extends MultiplayerSpawner

@export var bird_scene : PackedScene

@export var spawn_position : Vector2

@export var max_birds : int

@export var positional_change : int

var spacer = 0

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

func spawn_bird(_data):
	var bird = bird_scene.instantiate()
	
	bird.position.x = spawn_position.x - positional_change + spacer
	bird.positionY = spawn_position.y
	
	spacer += randf_range(40, 70)
	
	positions.append(bird.position.x)
	
	if (spawn_position.x - positional_change + spacer) > spawn_position.x + positional_change:
		birds = 0
	
	return bird
