extends Interactable

@onready var area = $Area2D
@onready var sprite = $AnimatedSprite2D

var speed = {}
var jump_power = {}

var controler = preload("res://Scripts/LiquidDrum/slip_overider.gd")

func _ready():
	area.body_entered.connect(slip_add)
	area.body_exited.connect(slip_remove)
	
	GlobalScript.important_positions[position] = 5

func action():
	sprite.play("Emptying")
	
	await sprite.animation_finished
	
	sprite.play("Empty")

func slip_add(body):
	if sprite.animation == "Empty":
		speed[body] = body.main_vars_reset[0]
		jump_power[body] = body.main_vars_reset[1]
		
		body.main_vars.air_vars["jump_power"] = 10
		body.main_vars_reset[1] = 10
		body.main_vars.ground_vars["speed"] = 200
		body.main_vars_reset[0] = 200

func slip_remove(body):
	if sprite.animation == "Empty":
		body.main_vars.ground_vars["speed"] = speed[body]
		body.main_vars_reset[0] = speed[body]
		speed.erase(body)
		
		body.main_vars.air_vars["jump_power"] = jump_power[body]
		body.main_vars_reset[1] = jump_power[body]
		jump_power.erase(body)


func entered(has_entered : bool):
	if sprite.animation == "Full":
		if has_entered:
			sprite.play("Interactable")
		elif not has_entered and not interacted:
			sprite.play("Full")
