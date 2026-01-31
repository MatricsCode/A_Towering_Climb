extends Control

var player_selector = preload("res://Scenes/PlayerSelector.tscn")

func TEST_NAME_1():
	for i in GlobalScript.player_positions_y:
		var play_select = player_selector.new()
		play_select.main_player = false
		play_select.current_player = i
		play_select.main_screen = self
