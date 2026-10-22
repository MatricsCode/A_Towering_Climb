extends Node

var levels = [preload("uid://cn8yrub2tv3vi")] #[preload("uid://bb64cr50jmhs8"),
	#preload("uid://c04puj7j1jrp"),
	#preload("uid://cn8yrub2tv3vi"),]

func _ready():
	Signals.lobby_start_game.connect(_level_select)
	if Steam.getSteamID() == Steam.getLobbyOwner(Networking.current_lobby):
		Signals.lobby_start_game.connect(_spawn_players())

func _level_select():
	var level_number = levels[randi_range(0, levels.size()-1)]
	var level = level_number.instantiate()
	
	add_child(level)

func _spawn_players():
	while GlobalScript.player_prefab.size() != int(Steam.getLobbyData(Networking.current_lobby, "peer_count")):
		print("dave")
	
