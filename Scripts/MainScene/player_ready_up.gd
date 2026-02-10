extends Control

@onready var main_container = $VBoxContainer/MainContainer

const PLAYER_SELECTOR = preload("res://Scenes/PlayerSelector.tscn")

var everyone_readyed = []

var host = false

func _physics_process(delta):
	if main_container.get_child_count() < Steam.getNumLobbyMembers(get_parent().lobby_id):
		everyone_readyed.append(false)
		
		var play_select = PLAYER_SELECTOR.instantiate()
		
		main_container.add_child(play_select)
		
		
		if play_select.get_index() == 0:
			play_select.main_player = true
		else:
			play_select.main_player = false
		
		play_select.main_screen = self
		
		GlobalScript.player_outfits.append(0)
		
	elif main_container.get_child_count() > Steam.getNumLobbyMembers(get_parent().lobby_id):
		main_container.get_child(main_container.get_child_count() - 1).queue_free()
		
		GlobalScript.player_outfits.remove_at(GlobalScript.player_outfits.size())
	
	if Input.is_action_pressed("Dev2"):
		print(Steam.getNumLobbyMembers(get_parent().lobby_id))
	elif Input.is_action_just_released("Dev2"):
		print("-------")

func start():
	visible = true

func reset():
	visible = false
	
	for i in main_container.get_children():
		i.queue_free()


func ready(readied : bool, index : int):
	everyone_readyed[index] = readied
	
	if everyone_readyed.find(false) == -1 and host:
		$VBoxContainer/Ready.disabled = false
		$VBoxContainer/Ready.text = "Ready when you are"
	
	elif everyone_readyed.find(false) == -1 and not host:
		$VBoxContainer/Ready.disabled = true
		$VBoxContainer/Ready.text = "Waiting for host"
	
	else:
		$VBoxContainer/Ready.disabled = true
		$VBoxContainer/Ready.text = "Waiting..."

# Main part of the code is in the Root node, Node2D!
func _on_ready_pressed():
	for i in main_container.get_children():
		GlobalScript.player_outfits[i.get_index()] = i.outfit
