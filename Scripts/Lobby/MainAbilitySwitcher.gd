extends Area2D

var players = []

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)

func _body_entered(body : Player):
	players.append(body)
func _body_exited(body : Player):
	players.erase(body)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		for player in players:
			if player.player_source.steam_ID == Steam.getSteamID():
				player.current_state = player.States.OVERIDDEN
				
