extends Control

signal finished()

enum States {SPAWN, CHARACTER, ABILITIES, FINISHED}

const CLIMBER_1 = preload("uid://c2turr7b108g7")
const RAM = preload("uid://b0imh5jcjfvpr")
const CLIMBER_SECRET = preload("uid://dbqffofmlv0yn")

var current_state =  States.SPAWN

@export var selected_character : PlayerSource

@export var background : Panel
@export var CharacterSelector : MarginContainer
@export var AbilitiySelector : MarginContainer

@export var remove_buttons : Array[HoverButton]

@export var start_button : HoverButton
@export var costume_buttons : Array[HoverButton]
@export var ability_buttons : Array[HoverButton]
@export var finished_button : HoverButton

@onready var animations = $AnimationPlayer

var loaded := false
var active := false

func _ready():
	animations.play("Start")
	
	for remove_button in remove_buttons:
		remove_button.pressed.connect(func(): 
			loaded = false
			active = false
			selected_character = null
			animations.play("RemoveInput"))
	
	start_button.pressed.connect(_start)
	for ability_button in ability_buttons:
		ability_button.pressed.connect(func():
			active = false
			animations.play("ToAbilities"))
	for costume_button in costume_buttons:
		costume_button.pressed.connect(func():
			active = false
			animations.play("ToCostumes"))
	finished_button.pressed.connect(func():
		active = true
		animations.play("Finished")
		finished.emit())

func _start():
	start_button.visible = false
	
	selected_character = PlayerSource.new()
	selected_character.sprite_frame = CLIMBER_1
	selected_character.main_ability = RAM
	selected_character.passive_ability_1 = RAM
	selected_character.passive_ability_2 = RAM
	selected_character.secret_ability = CLIMBER_SECRET
	
	animations.play("SpawnIn")
	
	loaded = true
























#var main_screen
#var player = 0
#
#var temp_ability_list = ["Glide", "Ram", "Sandwich"]
#
#@onready var ready_button = $VBoxContainer/Ready
#@onready var back_button = $VBoxContainer/Back
#
#@onready var abilitys_container = $VBoxContainer/ScrollContainer/HSplitContainer
#@onready var button_container = $VBoxContainer/ScrollContainer/HSplitContainer/Buttons
#@onready var indicator_container = $VBoxContainer/ScrollContainer/HSplitContainer/Indicators
#
#@onready var sprite = $CenterContainer/AnimatedSprite2D
#
#@export var text = "Ready?" 
#
#@export var readied_up = false
#
## Called when the node enters the scene tree for the first time.
#func _enter_tree():
	#await get_tree().create_timer(0.1).timeout
	#
	#GlobalScript.player_attributes.get_or_add(player, {"Position" : Vector2.ZERO, "Costume" : 0, "Abilities" : []})
	#
	#if player != GlobalScript.peer_ID:
		#for i in button_container.get_children():
			#i.disabled = true
		#
		#back_button.disabled = true
		#ready_button.disabled = true
	#
	#for i in indicator_container.get_children():
		#for y in temp_ability_list:
			#if i.name == y:
				#i.color = Color.html("#74a642")
	#button_container.get_child(0).grab_focus()
#
#func _physics_process(delta):
	#ready_button.text = text
	#
	#if player == GlobalScript.peer_ID:
		#if text == "Geared Up!":
			#main_screen.ready(true, get_index())
			#
		#elif text == "Ready?":
			#main_screen.ready(false, get_index())
#
#func button_pressed(button_name):
		#for i in GlobalScript.all_player_abilitys:
			#
			#if button_name == str(i):
				#
				#if not temp_ability_list.has(str(button_name)) and temp_ability_list.size() < 3:
					#temp_ability_list.append(str(button_name))
					#
					#for y in indicator_container.get_children():
						#if y.name == button_name:
							#y.color = Color.html("#74a642")
				#elif temp_ability_list.has(str(button_name)):
					#temp_ability_list.erase(str(button_name))
					#for y in indicator_container.get_children():
						#if y.name == button_name:
							#y.color = Color.html("#ff2f00")
				#return
#
#
#
#func _on_ready_pressed():
	#if text == "Ready?":
		#text = "Geared Up!"
		#
		#for i in button_container.get_children():
			#i.disabled = true
		#
		#main_screen.ready(true, get_index())
	#
	#elif text == "Changed my mind...":
		#text = "Ready?"
		#
		#for i in button_container.get_children():
			#i.disabled = false
		#
		#main_screen.ready(false, get_index())
	#
	#var sort_array = []
	#
	#for y in temp_ability_list:
		#sort_array.append(GlobalScript.all_player_abilitys.keys().find(y))
	#
	#while sort_array[sort_array.size() -2] > sort_array[sort_array.size() -1] or sort_array[0] > sort_array[1]:
		#for i in sort_array.size() -1:
			#if sort_array[i+1] < sort_array[i]:
				#var temp = sort_array[i+1]
				#sort_array[i+1] = sort_array[i]
				#sort_array[i] = temp
				#
				#var temp2 = temp_ability_list[i+1]
				#temp_ability_list[i+1] = temp_ability_list[i]
				#temp_ability_list[i] = temp2
	#
	#GlobalScript.player_abilitys = temp_ability_list
#
#func _on_ready_mouse_entered():
	#if text == "Geared Up!":
		#text = "Changed my mind..."
#
#func _on_ready_mouse_exited():
	#if text == "Changed my mind...":
		#text = "Geared Up!"
