extends Node2D

const TEST = preload("uid://840aay6lblgc")

var player : Player 
var label : Label
var ready_check : Sprite2D

var is_ready := false

func _ready():
	player = get_parent()
	label = player.steam_name
	
	await get_tree().create_timer(0.1).timeout
	
	ready_check = Sprite2D.new()
	
	ready_check.texture = TEST
	
	add_child(ready_check)
	ready_check.position = label.position
	ready_check.position.x = label.size.x / 2 + 50
	ready_check.visible = is_ready

func _physics_process(delta):
	if Input.is_action_just_pressed("Interact"):
		is_ready = !is_ready
		ready_check.visible = is_ready
		_send_data.rpc()

@rpc("any_peer", "call_local", "reliable")
func _send_data():
	Signals.player_ready.emit([player, is_ready, player.player_source])
