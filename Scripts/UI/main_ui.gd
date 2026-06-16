extends Control

var ability_list = [preload("res://Art/Abilitys/Abilitys3.png"), 
	preload("res://Art/Abilitys/Abilitys2.png"), 
	preload("res://Art/Abilitys/Abilitys5.png"),
	preload("res://Art/Abilitys/Abilitys4.png"), 
	preload("res://Art/Abilitys/Abilitys1.png")]
@onready var timer = $StartTimer/Timer
@onready var timer_text = $StartTimer/Timer_text
var time_left = GlobalScript.countdown_timer


func _ready():
	timer_text.text = str(time_left)
	
	await get_tree().create_timer(0.1).timeout
	
	for i in get_child_count(true):
		var child = get_child(i)
		child.visible = true
	
	#for i in GlobalScript.player_attributes.keys():
		#var ability = Label.new()
		#ability.text = i
		#ability.name = i
		#
		#$Abilitys.add_child(ability)
		
		#var picture = Sprite2D.new()
		#
		#for y in GlobalScript.all_player_abilitys.size():
			#var keys = GlobalScript.all_player_abilitys.keys() 
			#if keys[y] == i:
				#picture.texture = ability_list[y]
		
		#picture.position.x = 75
		#picture.position.y = 140 * ($Abilitys.get_child_count() -1)

func _on_leave_lobby_pressed():
	get_tree().paused = false
	GlobalScript.left_lobby.emit()


func _on_timer_timeout():
	time_left -= 1
	timer_text.text = str(time_left)
	
	if time_left > 0:
		timer.start()
	elif time_left == 0:
		timer_text.text = "GO!"
		timer.start()
	else:
		timer_text.text = ""
