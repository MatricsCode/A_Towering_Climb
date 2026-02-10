extends abilitys

var to_throw = []

var area = CollisionShape2D

func _ready():
	player.main_vars.climbing_vars.climbing_speed *= 1.5
	
	var scanner = Area2D.new()
	scanner.body_entered.connect(throw_player)
	scanner.body_exited.connect(throw_player)
	
	var hit_area = CollisionShape2D.new()
	
	hit_area.position.y = -181.0
	hit_area.shape = RectangleShape2D.new()
	
	add_child(scanner)
	
	scanner.add_child(hit_area)
	
	for i in get_children(true):
		if i.is_class("Area2D"):
			area = i

func _physics_process(_delta):
	area.position = player.position
	
	if to_throw.size() != 0 and Input.is_action_pressed("Interact"):
		for i in to_throw:
			i.position.x = 5 * player.get_sprite_rotation() * -1
			i.velocity.x = player.get_sprite_rotation() * player.main_vars.climbing_animation.climbing_speed * -10

func throw_player(body):
	if not to_throw.has(body):
		to_throw.append(body)
	else:
		to_throw.erase(body)
