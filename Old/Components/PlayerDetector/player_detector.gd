extends Area2D

signal return_player

var players_inside_area = []

func _return_players():
	return players_inside_area

func _on_body_entered(body):
	if players_inside_area.find(body) == -1:
		players_inside_area.append(body)
	
	return_player.emit(players_inside_area)
func _on_body_exited(body):
	players_inside_area.erase(body)
