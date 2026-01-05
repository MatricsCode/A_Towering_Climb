extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	print_rich("You are using the Steam ID of [wave][color=green][b]Railink[/b]")
	
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamGameID", str(480))
	#OS.set_environment("SteamAppID", str(2860890))
	#OS.set_environment("SteamGameID", str(2860890))
	Steam.steamInitEx()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	Steam.run_callbacks()
