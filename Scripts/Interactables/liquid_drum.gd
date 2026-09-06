extends Interactable

@onready var area = $PlayerScanner
@onready var sprite = $AnimatedSprite2D

var speed = {}
var jump_power = {}

var players = []

func player_entered(player):
	if sprite.animation == "Full":
		sprite.play("Interactable")
	
	elif sprite.animation == "Empty":
		player.current_state = 4
		
		await get_tree().create_timer(0.2).timeout
		
		player.velocity.x = 100 * player.get_sprite_rotation()
		player.sprite.play("walk")

func player_exited(player):
	if sprite.animation == "Interactable":
		sprite.play("Full")
	
	player.current_state = 0

#func action():
	#sprite.play("Emptying")
	#
	#await sprite.animation_finished
	#
	#sprite.play("Empty")
#
#func slip_add(body):
	#if sprite.animation == "Empty":
		#speed[body] = body.main_vars_reset[0]
		#jump_power[body] = body.main_vars_reset[1]
		#
		#body.main_vars.air_vars["jump_power"] = 10
		#body.main_vars_reset[1] = 10
		#body.main_vars.ground_vars["speed"] = 200
		#body.main_vars_reset[0] = 200
#
#func slip_remove(body):
	#if sprite.animation == "Empty":
		#body.main_vars.ground_vars["speed"] = speed[body]
		#body.main_vars_reset[0] = speed[body]
		#speed.erase(body)
		#
		#body.main_vars.air_vars["jump_power"] = jump_power[body]
		#body.main_vars_reset[1] = jump_power[body]
		#jump_power.erase(body)
#
#
#func entered(has_entered : bool):
	#if has_entered and sprite.animation == "Full":
		#sprite.play("Interactable")
	#elif has_entered == false and not interacted:
		#sprite.play("Full")

func _ready():
	GlobalScript.important_positions[position] = 5

func _physics_process(delta):
	if players.is_empty() == false and sprite.animation == "Full":
		sprite.play("Emptying")
		
		await sprite.animation_finished
		
		sprite.play("Empty")
