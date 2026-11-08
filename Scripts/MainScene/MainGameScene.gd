extends Node

const PLAYER = preload("uid://c2kbb3vdndd4g")
const LOBBY = preload("uid://cefq6hcwel7wc")
const CAMERA = preload("uid://n84h7ds41dm6")

var levels = [preload("uid://cn8yrub2tv3vi")] #[preload("uid://bb64cr50jmhs8"),
	#preload("uid://c04puj7j1jrp"),
	#preload("uid://cn8yrub2tv3vi"),]

var lobby : Node2D
var level : Node2D
var camera : Node2D

var spawned_player_count := 0

@export var player_placements : Node2D

func _ready():
	lobby = LOBBY.instantiate()
	add_child(lobby)
	
	Signals.lobby_start_game.connect(_level_select)
	Signals.lobby_finished_game.connect(func():
		lobby = LOBBY.instantiate()
		add_child(lobby))
	#if Networking.peer.get_unique_id() == Steam.getLobbyOwner(Networking.current_lobby):
	#Signals.lobby_start_game.connect(_spawn_players)
	await get_tree().create_timer(0.1).timeout
	_spawn_players()
	move_child(player_placements, get_child_count()-1)

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
	camera.player = GlobalScript.players.get(Steam.getSteamID())[0]
	add_child(camera)
	
	move_child(player_placements, get_child_count()-1)
	
	Signals.start_anim_finished.emit()
	
	lobby.queue_free()

func _spawn_players():
	var _owner = Steam.getLobbyOwner(Networking.current_lobby)
	var _self = Steam.getSteamID()
	
	if !Networking.host and player_placements.get_child_count() > 1:#Steam.getSteamID() != Steam.getLobbyOwner(Networking.current_lobby):
		return
	
	await get_tree().create_timer(0.1).timeout
	
	var player_count = player_placements.get_children().size()
	while player_count > 1:
		player_placements.get_child(1).queue_free()
		player_count -= 1
	
	var player = PLAYER.instantiate()
	
	player_placements.add_child(player)
	
	player.position.y = -250
	spawned_player_count += 1
	
	player.start.emit([str(Steam.getPersonaName(), "_", 
		spawned_player_count), Steam.getSteamID(), spawned_player_count])
	
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
func _remove_players(Number : int):
	pass
