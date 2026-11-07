extends Node2D

var players : Dictionary[int, Array]


func _count():
	players.clear()
	GlobalScript.players.clear()
	
	for i in get_children():
		
		if i.get_index() != 0:
			_sort(i)
	
	GlobalScript.players = players
	return true

func _sort(player : Player):
	var player_source = player.player_source
	
	if players.has(player_source.steam_ID) == false:
		players[player_source.steam_ID] = [player]
	
	var sort_players : Array[Player]
	
	sort_players = players[player_source.steam_ID]
	
	for i in sort_players.size()-1:
		var current_player = sort_players[i]
		var next_player = sort_players[i+1]
		
		if current_player.player_source.player_number > next_player.player_source.player_number:
			var temp = current_player
			sort_players[i] = next_player
			sort_players[i+1] = temp
