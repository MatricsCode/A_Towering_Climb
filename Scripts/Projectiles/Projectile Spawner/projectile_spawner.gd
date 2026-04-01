extends MultiplayerSpawner

func _ready():
	spawn_function = spawn_projectile
	
	GlobalScript.projectile.connect(spawn)

func spawn_projectile(data):
	var projectile = data.get(0).instantiate()
	
	projectile.position.x = data.get(1).x + 150 * data.get(2) 
	projectile.position.y = data.get(1).y - 100
	
	projectile.direction = data.get(2)
	
	return projectile
