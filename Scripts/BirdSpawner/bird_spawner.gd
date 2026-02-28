extends MultiplayerSpawner

const BIRD = preload("res://Scenes/Bird.tscn")

@export var spawn_positions : Array[Array]

var birds_required = 0

var current_position = []
var positions = [Vector2(0, 0)]
var spawning = true

var birds_spawned = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	positions.append(spawn_positions.get(0).get(0))
	
	var    areas = spawn_positions.size()
	
	if is_multiplayer_authority():
		spawn_function = spawn_bird
		
		if spawn_positions == null:
			push_error("You didn't assing the positional node to the birdspawner called: ", name)
		
		while spawning == true:
			if birds_spawned > spawn_positions.size():
				spawning = false
			
			birds_spawned += 1
			spawn(current_position)

func spawn_bird(data : Array):
	var bird = BIRD.instantiate()
	var bird_position : Vector2
	
	
	if positions.get(positions.size() - 1).y != data.get(0).y:
		bird_position = data.get(0)
	
	else:
		var position_x = data.get(1).x - positions.get(positions.size() - 1).x
		
		if position_x + 200 < data.get(1).x:
			position_x += randf_range(40, 200)
		elif position_x + 40 < data.get(1).x:
			position_x += 40
			
			if current_position < positions.size() -1:
				current_position += 1
			else:
				spawning = false
		
		bird_position = Vector2(position_x, float(data.get(1).y))
	
	return bird
	
	bird.position = bird_position
