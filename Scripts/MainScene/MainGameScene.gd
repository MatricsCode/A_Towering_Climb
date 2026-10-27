extends Node

const PLAYER = preload("uid://c2kbb3vdndd4g")

var levels = [preload("uid://cn8yrub2tv3vi")] #[preload("uid://bb64cr50jmhs8"),
	#preload("uid://c04puj7j1jrp"),
	#preload("uid://cn8yrub2tv3vi"),]

@export var player_placements : Node2D

func _ready():
	Signals.lobby_start_game.connect(_level_select)
	#if Networking.peer.get_unique_id() == Steam.getLobbyOwner(Networking.current_lobby):
	Signals.lobby_start_game.connect(_spawn_players)

func _level_select():
	var level_number = levels[randi_range(0, levels.size()-1)]
	var level = level_number.instantiate()
	
	add_child(level)

func _spawn_players():
	var _owner = Steam.getLobbyOwner(Networking.current_lobby)
	var _self = Steam.getSteamID()
	
	if Steam.getSteamID() != Steam.getLobbyOwner(Networking.current_lobby):
		return
	
	await get_tree().create_timer(0.1).timeout
	
	for player_ID in GlobalScript.players:
		var player_data : Array
		player_data = GlobalScript.players[player_ID]
		for players in player_data:
			var player = PLAYER.instantiate()
			var player_data_2 : PlayerSource
			player_data_2 = players
			
			player.player_source = player_data_2
			
			player_placements.add_child(player)
			player.position.y = -10
			
			player.start.emit()
