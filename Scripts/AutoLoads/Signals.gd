extends Node2D

# These are the basic Steam Signals, required for creating, entering and exiting a lobby:
# They also set the lobby ID in "Networking"
## This signal is emited once a Lobby is created and contains the coresponding lobbies ID
@warning_ignore("unused_signal") signal host_created(lobby_id : int)
## This signal is emited once your peer joins a lobby (also emited when a lobby is created)
## and contains the coresponding lobbies ID
@warning_ignore("unused_signal") signal lobby_joined(lobby_id : int)
## This signal is emited once your peer leaves a lobby (Not being emited yet)
## and contains the coresponding lobbies ID
@warning_ignore("unused_signal") signal lobby_left(lobby_id : int)

# These are more localised signals, for main actions which happen inside a lobby,
# Like the game starting (loading the level), the game finishing and the game returning to the lobby level
## This signal is emitted once every player has readied up! It loads the level and despawns the lobby scene
@warning_ignore("unused_signal") signal lobby_start_game()
## This signal is emitted once one player has reached the flagpole
@warning_ignore("unused_signal") signal lobby_finished_game(winner : int)
## This signal is emitted once 
@warning_ignore("unused_signal") signal lobby_return_to_lobby()

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
signal lobby_match_list(lobbies : Array)
@warning_ignore("unused_signal")
signal request_lobby_list()

@warning_ignore("unused_signal")
signal start_camera_zoom_finished()
@warning_ignore("unused_signal")
signal start_anim_finished()



@warning_ignore("unused_signal")
signal vignette(trans_time : float, wait_time : float)
@warning_ignore("unused_signal")
signal camera_zoom(camera : int, zoom_level : float, time : float)
@warning_ignore("unused_signal")
signal text_popup(text : String, text_position : Vector2)

@warning_ignore("unused_signal")
signal paused(is_paused : bool)

@warning_ignore("unused_signal")
signal debug(is_debug : bool)
