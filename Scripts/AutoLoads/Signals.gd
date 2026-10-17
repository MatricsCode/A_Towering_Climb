extends Node2D

signal host_created(lobby_id : int) 
signal lobby_joined(lobby_id : int)
signal lobby_left()

signal lobby_match_list(lobbies : Array)
signal request_lobby_list()

signal lobby_start_game()
signal lobby_pause_game()
signal lobby_finished_game(winner : int)

signal player_list(player_prefab : PlayerSource)

signal projectile (type)

signal winner (name)
signal reset()
signal left_lobby()
signal paused()
signal start (Something : int)
