extends Node

const PLAYER = preload("uid://c2kbb3vdndd4g")
const LOBBY = preload("uid://cefq6hcwel7wc")
const CAMERA = preload("uid://n84h7ds41dm6")

const RAM = preload("uid://b0imh5jcjfvpr")
const GLIDE = preload("uid://d0y0w2hbe3jwq")
const CLIMBER_SECRET = preload("uid://dbqffofmlv0yn")
const CLIMBER_FRAMES = preload("uid://c2turr7b108g7")

var levels = [preload("uid://cn8yrub2tv3vi")] #[preload("uid://bb64cr50jmhs8"),
	#preload("uid://c04puj7j1jrp"),
	#preload("uid://cn8yrub2tv3vi"),]

var lobby : Node2D
var level : Node2D
var camera : Node2D

var spawned_players = []

@export var player_placements : Node2D

func _ready():
	lobby = LOBBY.instantiate()
	add_child(lobby)
	
	Signals.lobby_joined.connect(func(_ID): pass)
	Signals.lobby_start_game.connect(_level_select)
	Signals.lobby_finished_game.connect(func(_winner : Player):
		lobby = LOBBY.instantiate()
		await get_tree().create_timer(0.5).timeout
		add_child(lobby))
	
	#if Networking.peer.get_unique_id() == Steam.getLobbyOwner(Networking.current_lobby):
	#Signals.lobby_start_game.connect(_spawn_players)
	await get_tree().create_timer(0.1).timeout
	move_child(player_placements, get_child_count()-1)

func _physics_process(_delta):
	if Input.is_action_just_pressed("P1_Ability") and !spawned_players.has(1):
		_spawn_players(1)
	elif Input.is_action_just_pressed("P2_Ability") and !spawned_players.has(2):
		_spawn_players(2)
	elif Input.is_action_just_pressed("P3_Ability") and !spawned_players.has(3):
		_spawn_players(3)
	elif Input.is_action_just_pressed("P4_Ability") and !spawned_players.has(4):
		_spawn_players(4)

func _level_select():
	camera = CAMERA.instantiate()
	#for i in GlobalScript.players:
		#pass
	
	if level != null:
		level.queue_free()
	
	var level_number = levels[randi_range(0, levels.size()-1)]
	level = level_number.instantiate()
	
	Signals.vignette.emit(0.2, 1)
	
	await get_tree().create_timer(1.2).timeout
	
	add_child(level)
	
	await player_placements._count()
#	camera.player = GlobalScript.players.get(Steam.getSteamID())[0]
	add_child(camera)
	
	move_child(player_placements, get_child_count()-1)
	
	Signals.start_anim_finished.emit()
	
	lobby.queue_free()

func _spawn_players(number : int):
	var _owner = Steam.getLobbyOwner(Networking.current_lobby)
	var _self = Steam.getSteamID()
	
	if !Networking.host and player_placements.get_child_count() > 1:#Steam.getSteamID() != Steam.getLobbyOwner(Networking.current_lobby):
		return
	
	#var player_count = player_placements.get_children().size()
	#while player_count > 1:
		#player_placements.get_child(1).queue_free()
		#player_count -= 1
	
	var player_source = PlayerSource.new()
	
	player_source.player_name = str(Steam.getPersonaName(), "_", number)
	player_source.player_number = number
	player_source.main_ability = RAM
	player_source.passive_ability = GLIDE
	player_source.secret_ability = CLIMBER_SECRET
	player_source.sprite_frame = CLIMBER_FRAMES
	
	
	var player = PLAYER.instantiate()
	player.player_source = player_source
	
	player_placements.add_child(player)
	
	spawned_players.append(number)
	
	player.position.y = -250
	if !GlobalScript.players.has(Steam.getSteamID()):
		GlobalScript.players[Steam.getSteamID()] = []
	GlobalScript.players.get(Steam.getSteamID()).append(player)
	
	Signals.player_created.emit(player)
	
	#for player_ID in GlobalScript.players:
		#var player_data : Array
		#player_data = GlobalScript.players[player_ID]
		#for players in player_data:
			#var player = PLAYER.instantiate()
			#var player_data_2 : PlayerSource
			#player_data_2 = players
			#
			#player.player_source = player_data_2
			#
			#player_placements.add_child(player)
			#player.position.y = -10
			#
			#player.start.emit()
