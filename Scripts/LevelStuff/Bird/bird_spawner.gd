extends MultiplayerSpawner

const BIRD = preload("res://Scenes/Bird.tscn")

@export var spawn_positions : Array[Array]

#var current_position = []
#var relative_position = 0
#var positions = [Vector2(0, 0)]
#var spawning = true
#
#var birds_spawned = 0

var spawn_area = 0 ## Determins which two positions in spawn_positions are currently used
var spawn_sector : Array ## The current two positions which determin where the birds can spawn
var current_horizontal_position = 0

var total_spawned_birds : int ## The total amount of birds
var spawning = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if spawn_positions.is_empty():
		push_error("You didn't assing the positional node to the birdspawner called: ", name)
		return
	
	spawn_area = 0
	current_horizontal_position = spawn_positions.get(spawn_area).get(0).x
	
	spawn_function = spawn_bird
	
	while spawning:
		total_spawned_birds += 1
		spawn("null")

func spawn_bird(data = null):
	var bird = BIRD.instantiate()
	var bird_position : Vector2
	
	bird_position = Vector2(current_horizontal_position, spawn_positions.get(spawn_area).get(0).y)
	
	if current_horizontal_position < spawn_positions.get(spawn_area).get(1).x:
		current_horizontal_position += randf_range(60, 120)
	
	elif spawn_area < spawn_positions.size() - 1:
		spawn_area += 1
		current_horizontal_position = spawn_positions.get(spawn_area).get(0).x
	
	else:
		spawning = false
	
	bird.position.x = bird_position.x
	bird.position.y = bird_position.y
	
	return bird








	#var bird = BIRD.instantiate()
	#var bird_position : Vector2
	#
	#if positions.get(relative_position).y != current_position.get(0).y:
		#relative_position += 1
		#bird_position = current_position.get(0)
	#
	#else:
		#var position_x = current_position.get(1).x - positions.get(relative_position).x
		#
		#if position_x + 200 < current_position.get(1).x:
			#position_x += randf_range(40, 200)
		#elif position_x + 40 < current_position.get(1).x:
			#position_x += 40
			#
			#if current_position < positions.size() -1:
				#current_position += 1
			#else:
				#spawning = false
		#
		#bird_position = Vector2(position_x, float(current_position.get(1).y))
	#
	#bird.position = bird_position
	#
	#return bird
