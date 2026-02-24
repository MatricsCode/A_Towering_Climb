extends Panel

var main_screen
var main_player = false

@onready var ready_button = $VBoxContainer/Ready

@onready var main_container = $VBoxContainer/Main
@onready var abilitys_container = $VBoxContainer/Abilitys
@onready var outfits_container = $VBoxContainer/Outfits
@onready var indicator_container = $VBoxContainer/Abilitys/HSplitContainer/Indicators

@onready var sprite = $VBoxContainer/CenterContainer/AnimatedSprite2D

@export var outfit = 0
@export var text = "Ready?" 

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	await get_tree().create_timer(0.1).timeout
	
	if main_player == false:
		for i in main_container.get_children():
			i.disabled = true
			ready_button.disabled = true
	
	for i in indicator_container.get_children():
		for y in GlobalScript.player_abilitys:
			if i.name == y:
				i.color = Color.html("#74a642")

func _physics_process(delta):
	ready_button.text = text
	
	if ready_button.disabled == true:
		if text == "Geared Up!":
			main_screen.ready(true, get_index())
			
		elif text == "Ready?":
			main_screen.ready(false, get_index())
		
		sprite.animation = str(outfit)

func button_pressed(name):
	if name != ready_button.name:
		text = "Back"
	
	if name == "Abilitys":
		
		main_container.visible = false
		abilitys_container.visible = true
		
		return
	elif name == "Outfits":
		
		main_container.visible = false
		outfits_container.visible = true
		
		return
	 
	else:
		for i in GlobalScript.all_player_abilitys:
			
			if name == str(i):
				
				if not GlobalScript.player_abilitys.has(str(name)) and GlobalScript.player_abilitys.size() < 3:
					GlobalScript.player_abilitys.append(str(name))
					
					for y in indicator_container.get_children():
						if y.name == name:
							y.color = Color.html("#74a642")
				elif GlobalScript.player_abilitys.has(str(name)):
					GlobalScript.player_abilitys.erase(str(name))
					for y in indicator_container.get_children():
						if y.name == name:
							y.color = Color.html("#ff2f00")
				print(GlobalScript.player_abilitys)
				return
		
		for i in outfits_container.get_children():
			if i.name == name:
				GlobalScript.player_outfits[0] = i.get_index()
				sprite.animation = str(i.get_index())
				outfit = i.get_index()



func _on_ready_pressed():
	if text == "Ready?":
		text = "Geared Up!"
		
		for i in main_container.get_children():
			i.disabled = true
		
		main_screen.ready(true, get_index())
	
	elif text == "Changed my mind...":
		text = "Ready?"
		
		for i in main_container.get_children():
			i.disabled = false
		
		main_screen.ready(false, get_index())
	
	elif text == "Back":
		main_container.visible = true
		abilitys_container.visible = false
		outfits_container.visible = false
		
		text = "Ready?"

func _on_ready_mouse_entered():
	if text == "Geared Up!":
		text = "Changed my mind..."

func _on_ready_mouse_exited():
	if text == "Changed my mind...":
		text = "Geared Up!"
