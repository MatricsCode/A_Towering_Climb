extends StaticBody2D

@export var spill_colour : Color

var player = null

var entered = []

@onready var area = $Area2D
@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

var controler = preload("res://Scripts/LiquidDrum/slip_overider.gd")
func _ready():
	area.body_entered.connect(player_array)
	area.body_exited.connect(player_array)

func _physics_process(_delta):
	if player != null and sprite.animation == "Full":
		$Label.visible = true
	else:
		$Label.visible = false
	
	if player != null and Input.is_action_pressed("Interact") and sprite.animation == "Full":
		empty()

func empty():
	sprite.play("Emptying")
	await sprite.animation_finished
	
	for i in entered:
		player_slip(i)
	
	sprite.play("Empty")
	
	area.body_entered.disconnect(player_array)
	area.body_exited.disconnect(player_array)
	
	area.body_entered.connect(player_slip)
	area.body_exited.connect(player_slip)

func player_array(body):
	if entered.find(body) == -1:
		entered.append(body)
	else:
		entered.erase(body)
	
	var key_search = body.get_children(true)
	
	var key = GlobalScript.all_player_abilitys.keys()
	
	if body.is_multiplayer_authority():
		for i in key_search:
			
			var children = i.get_children(true)
			
			for y in children:
				if y.name == key[4]:
					if player == null:
						player = body
					else:
						player = null
	else:
		pass

func player_slip(body):
	var key_search = body.get_children(true)
	
	var key = GlobalScript.all_player_abilitys.keys()
	
	if not body.is_multiplayer_authority():
		return
	else:
		for i in key_search:
			var children = i.get_children()
			
			for y in children:
				if y.name == key[4]:
					return
				
				if y.name == "slip_overider":
					y.reset()
					y.queue_free()
					return
		
		for i in key_search:
			
			if i.name == "Upgrades":
				var slip_controler = Node.new()
				slip_controler.name = "slip_overider"
				slip_controler.set_script(controler)
				
				slip_controler.player = i.main_player
				i.add_child(slip_controler)
