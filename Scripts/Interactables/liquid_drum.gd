extends Interactable

@onready var area = $Area2D
@onready var sprite = $AnimatedSprite2D

var controler = preload("res://Scripts/LiquidDrum/slip_overider.gd")

func action():
	sprite.play("Emptying")
	
	set_collision_layer_value(5, false)
	
	await sprite.animation_finished
	
	sprite.play("Empty")
	
	area.body_entered.connect(player_slip_add)
	area.body_exited.connect(player_slip_remove)

func player_slip_add(body):
	var key_search = body.get_children(true)
	
	var key = GlobalScript.all_player_abilitys.keys()
	
	var upgrade_node = null
	
	for i in key_search:
		if i.name == "Upgrades":
			upgrade_node = i
	
	for i in upgrade_node.get_children():
		if i.name == key[4]:
			return
	
	var slip_controler = Node.new()
	slip_controler.name = "slip_overider"
	slip_controler.set_script(controler)
	
	slip_controler.player = upgrade_node.main_player
	upgrade_node.add_child(slip_controler)

func player_slip_remove(body):
	var key_search = body.get_children(true)
	
	var key = GlobalScript.all_player_abilitys.keys()
	
	for i in key_search:
		var children = i.get_children()
		
		for y in children:
			
			if y.name == "slip_overider":
				y.reset()
				y.queue_free()
				return
