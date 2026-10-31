extends Panel

@export_group("Buttons")
@export var continue_button : HoverButton
@export var change_character_button : HoverButton
@export var leave_lobby_button : HoverButton
@export var quit_button : HoverButton

@export_group("Winner")
@export var centre_point : Control
@export var sprite : AnimatedSprite2D
@export var main_ability : Label
@export var sec1_ability : Label
@export var sec2_ability : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	continue_button.pressed.connect(func(): 
		if Networking.host:
			_continue.rpc()
			get_parent()._change_ui("FinishedUI", "GameUI"))
	change_character_button.pressed.connect(func(): 
		pass)
	leave_lobby_button.pressed.connect(func(): 
		Networking._leave_lobby(Networking.current_lobby))
	quit_button.pressed.connect(func(): 
		get_tree().quit())
	
	Signals.lobby_finished_game.connect(_display_winner)

func _display_winner(winner : Player):
	var winner_display : PlayerSource
	winner_display = winner.player_source
	
	sprite.modulate = Color.TRANSPARENT
	sprite.scale = Vector2.ZERO
	sprite.sprite_frames = winner_display.sprite_frame
	sprite.play("walk")
	
	await get_tree().create_timer(0.1).timeout
	
	var tweener = get_tree().create_tween()
	tweener.set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	tweener.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	tweener.tween_property(sprite, "scale", Vector2.ONE, 0.1)
	tweener.tween_property(sprite, "position", centre_point.position, 0.1)
	


@rpc ("authority", "call_local", "reliable")
func _continue():
	Signals.lobby_start_game.emit()
