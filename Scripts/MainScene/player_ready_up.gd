extends Control

@onready var main_container = $VBoxContainer/MainContainer

const PLAYER_SELECTOR = preload("res://Scenes/PlayerSelector.tscn")

var everyone_readyed = []

var host = false

func start():
	visible = true
	
	print(GlobalScript.player_outfits)
	
	for i in GlobalScript.player_outfits.size():
		everyone_readyed.append(false)
		
		var play_select = PLAYER_SELECTOR.instantiate()
		
		main_container.add_child(play_select)
		
		
		if i == 0:
			play_select.main_player = true
		else:
			play_select.main_player = false
		
		play_select.current_player = i
		play_select.main_screen = self

func reset():
	visible = false
	
	for i in main_container.get_children():
		i.queue_free()

func ready(readied : bool):
	everyone_readyed.erase(not readied)
	everyone_readyed.append(readied)
	
	if everyone_readyed.find(false) == -1 and host:
		$VBoxContainer/Ready.disabled = false
		$VBoxContainer/Ready.text = "Ready when you are"
	
	elif everyone_readyed.find(false) == -1 and not host:
		$VBoxContainer/Ready.disabled = true
		$VBoxContainer/Ready.text = "Waiting for host"
	
	else:
		$VBoxContainer/Ready.text = "Waiting..."
		$VBoxContainer/Ready.disabled = true
