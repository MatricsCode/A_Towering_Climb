extends MarginContainer

const MAIN_ABILITIES = {preload("uid://b0imh5jcjfvpr") : "Ram", 
	preload("uid://bpmhsc3tdcpqq") : "DummyAbility1", preload("uid://dvnr5lwr2t2n8") : "DummyAbility2"}
const PASS_ABILITIES = {preload("uid://d0y0w2hbe3jwq") : "Glide", preload("uid://cx4jckeql12mb") : "DrumKey", 
	preload("uid://bpmhsc3tdcpqq") : "DummyAbility1", preload("uid://dvnr5lwr2t2n8") : "DummyAbility2"}

@export var center_point : Control
@export var sprite : AnimatedSprite2D
@export var main_ability : Label
@export var pass_ability : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.lobby_finished_game.connect(_winner)

func _winner(player : Player):
	sprite.sprite_frames = player.player_source.sprite_frame
	sprite.play("idle")
	sprite.position = center_point.position
	main_ability.text = MAIN_ABILITIES[player.player_source.main_ability]
	pass_ability.text = PASS_ABILITIES[player.player_source.passive_ability]
	
	await get_tree().create_timer(5).timeout
	
	Signals.vignette.emit(1,0.5)
	await get_tree().create_timer(1).timeout
	visible = false
