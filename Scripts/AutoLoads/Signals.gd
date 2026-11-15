extends Node2D

@warning_ignore("unused_signal")
signal host_created(lobby_id : int) 
@warning_ignore("unused_signal")
signal lobby_joined(lobby_id : int)
@warning_ignore("unused_signal")
signal lobby_left(lobby_id : int)

@warning_ignore("unused_signal")
signal lobby_match_list(lobbies : Array)
@warning_ignore("unused_signal")
signal request_lobby_list()

@warning_ignore("unused_signal")
signal lobby_start_game()
@warning_ignore("unused_signal")
signal lobby_finished_game(winner : int)
@warning_ignore("unused_signal")
signal lobby_return_to_lobby()

@warning_ignore("unused_signal")
signal peer_left(ID : int)
@warning_ignore("unused_signal")
signal peer_joined(ID : int)
@warning_ignore("unused_signal")
signal peer_waiting(ID : int)

@warning_ignore("unused_signal")
signal player_created(player : Player)
@warning_ignore("unused_signal")
signal player_deleted(player : Player)
@warning_ignore("unused_signal")
signal player_ready(info : Array)

@warning_ignore("unused_signal")
signal start_camera_zoom_finished()
@warning_ignore("unused_signal")
signal start_anim_finished()

@warning_ignore("unused_signal")
signal vignette(trans_time : float, wait_time : float)
@warning_ignore("unused_signal")
signal paused(is_paused : bool)
@warning_ignore("unused_signal")
signal text_popup(text : String, text_position : Vector2)

@warning_ignore("unused_signal")
signal debug(is_debug : bool)
