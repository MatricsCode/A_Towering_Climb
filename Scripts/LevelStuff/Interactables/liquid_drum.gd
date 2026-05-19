extends Interactable

@onready var area = $Area2D
@onready var sprite = $AnimatedSprite2D

var controler = preload("res://Scripts/LiquidDrum/slip_overider.gd")

func _ready():
	GlobalScript.important_positions[position] = 5

func entered(has_entered : bool):
	if has_entered:
		sprite.play("Interactable")
	elif not has_entered and not interacted:
		sprite.play("Full")

func action():
	sprite.play("Emptying")
	
	set_collision_layer_value(5, false)

func player_slip_add(body):
	var upgrade_node = null
	
	if body.player == 0:
		for i in GlobalScript.player_abilitys:
			if i == GlobalScript.all_player_abilitys[3]:
				return
		
		for i in body.get_children(true):
			if i.name == "Upgrade":
				upgrade_node = i
		
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


func _on_animated_sprite_2d_animation_finished():
	if sprite.frame == 15:
			sprite.play("Empty")
			
			area.body_entered.connect(player_slip_add)
			area.body_exited.connect(player_slip_remove)
