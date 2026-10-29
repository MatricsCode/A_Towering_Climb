extends Node2D

signal host_created(lobby_id : int) 
signal lobby_joined(lobby_id : int)
signal lobby_left()

signal lobby_match_list(lobbies : Array)
signal request_lobby_list()

signal lobby_start_game()
signal lobby_pause_game()
signal lobby_finished_game(winner : int)

signal peer_left(ID : int)
signal peer_joined(ID : int)
signal readied_peer(ID : int)
signal peer_waiting(ID : int)

signal vignette(trans_time : float, wait_time : float)

#-----------------------------------

signal projectile (type)

signal winner (name)
signal reset()
signal left_lobby()
signal paused()
signal start (Something : int)
