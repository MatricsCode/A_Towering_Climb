extends Node

@onready var ready_button = $MarginContainer/VBoxContainer/Ready

var func_parent : MultiplayerSpawner

var main_screen

var player : int
var costume : int
var abilities = {}

var green = Color.html("#74a642")
var red = Color.html("#ff2f00")

func _ready():
	print("---------------------")
	print("In the Player Selector Main Script you have 2 color variables, but they haven't been working properly!")
	print("---------------------")
	
	$MarginContainer/VBoxContainer/Label.text = str("ID: ", player)

func button_pressed(data):
	GlobalScript.player_attributes[player] = {}
	GlobalScript.player_attributes.get(player)["Position"] = Vector2(0,0)
	GlobalScript.player_attributes.get(player)["Costume"] = costume
	GlobalScript.player_attributes.get(player)["Abilities"] = abilities

	
	if abilities.values().size() < 3:
		ready_button.text = "Not all abilities Selected!"
		await get_tree().create_timer(1).timeout
		ready_button.text = "Ready?"
	
	elif ready_button.text == "Ready?":
		ready_button.text = "Readied!"
		func_parent._readied_up(player, true)
	
	elif ready_button.text == "Readied!":
		ready_button.text = "Ready?"
		func_parent._readied_up(player, false)
