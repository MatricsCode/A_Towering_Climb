extends Ability

var to_throw : Array[Player] = []
var scanner : Area2D

func _ready():
	activation_state = player.States.CLIMB
	
	player.main_vars.climbing_vars.climbing_speed *= 1.5
	
	scanner = Area2D.new()
	scanner.body_entered.connect(func(body): to_throw.append(body))
	scanner.body_exited.connect(func(body): to_throw.erase(body))
	
	var hit_area = CollisionShape2D.new()
	
	hit_area.position.y = -200
	hit_area.shape = RectangleShape2D.new()
	
	add_child(scanner)
	
	scanner.add_child(hit_area)

func _physics_process(_delta):
	scanner.position = player.position
	
	scanner.get_overlapping_bodies()
	
	if to_throw.size() != 0 and Input.is_action_pressed(player.inputs.Ability) and activation_state:
		for throwing_player in to_throw:
			throwing_player.current_state = throwing_player.States.AIR
			throwing_player.velocity.x = 250 * throwing_player._get_sprite_rotation() * -1
			throwing_player.velocity.y = -500
			throwing_player.air.can_control = false
			to_throw.erase(throwing_player)
