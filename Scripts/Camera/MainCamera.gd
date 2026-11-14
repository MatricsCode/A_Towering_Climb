extends Node2D

@export var player_node : Node2D
@export var item_node : Node2D
@export var win_node : Node2D

@export var indicator_up : Node2D
@export var indicator_down : Node2D
@export var indicator_left : Node2D
@export var indicator_right : Node2D
@export var indicator_center : Node2D

@onready var cam = $Camera2D
@onready var timer = $Timer

enum States {BOUNCING, STARTING_ANIMATION, FOLLOWING_PLAYER, FINISHED, OVERIDDEN}
var current_state := States.OVERIDDEN

var bouncing_time = 0

var easing :float = 1.0

var cam_x : float = 0
var cam_y : float = 0

var player : Player = null
var viewing_player : Player = null

var move_time : float = 2
var zoom_time : float = 3

var finish_tweener : Tween
var finish_tweener2 : Tween
var finish_tweener3 : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	#finish_tweener = get_tree().create_tween()
	#finish_tweener2 = get_tree().create_tween()
	#finish_tweener3 = get_tree().create_tween()
	
	current_state = States.OVERIDDEN
	
	
	Signals.lobby_start_game.connect(_start_animation)
	Signals.lobby_finished_game.connect(func(winner : Player):
		current_state = States.FINISHED
		viewing_player = winner
		_finished(winner))

func _physics_process(_delta):
	match current_state:
		States.BOUNCING:
			_bouncing()
		States.STARTING_ANIMATION:
			pass
		States.FOLLOWING_PLAYER:
			_following_player()
		States.FINISHED:
			pass

func _bouncing():
	position.x += 1
	position.y = -10000 + sin(bouncing_time) * 10
	bouncing_time += 0.01
	cam.zoom = Vector2(1 + cos(bouncing_time/2) * 0.1, 1 + cos(bouncing_time/2) * 0.1)
func _start_animation():
	if player == null:
		current_state = States.OVERIDDEN
		return
	
	current_state = States.STARTING_ANIMATION
	var start_anim : Tween
	
	Signals.vignette.emit(0.5,1)
	await get_tree().create_timer(0.5).timeout
	position = Vector2.ZERO
	cam.zoom = Vector2(0.25,0.25)
	await get_tree().create_timer(1.5).timeout
	
	#start_anim.kill()
	#start_anim = get_tree().create_tween()
	#start_anim.set_ease(Tween.EASE_OUT)
	#start_anim.tween_property(self, "position", Vector2(0,0), 2)
	#
	#await get_tree().create_timer(2.2).timeout
	#start_anim.kill()
	#start_anim = get_tree().create_tween()
	#start_anim.set_ease(Tween.EASE_OUT)
	#start_anim.tween_property(self, "position", Vector2(0,-7000), 2)
	#
	#await get_tree().create_timer(2.2).timeout
	start_anim = get_tree().create_tween()
	start_anim.set_parallel()
	start_anim.set_ease(Tween.EASE_OUT)
	start_anim.tween_property(self, "position", Vector2(0,0), 2)
	start_anim.tween_property(cam, "zoom", Vector2(0.5,0.5), 2)
	
	await start_anim.finished
	
	#if !get_parent().is_class("Player"):
		#for finding_player in player_node.get_children():
			#if finding_player is CharacterBody2D:
				#if finding_player.player_source.steam_ID == Steam.getSteamID():
					#player = finding_player
	
	Signals.start_camera_zoom_finished.emit()
	current_state = States.FOLLOWING_PLAYER
func _following_player():
	position = player.position
	
	var input_direction = Input.get_vector(player.inputs.Left, 
		player.inputs.Right, player.inputs.Up, player.inputs.Down)
	
	var target_x : float = 0
	var target_y : float = 0
	
	if input_direction.x == 0:
		target_x = indicator_center.position.x
	elif input_direction.x > 0:
		target_x = indicator_right.position.x
	elif input_direction.x < 0:
		target_x = indicator_left.position.x
	
	if input_direction.y == 0:
		target_y = indicator_center.position.y
	elif input_direction.y > 0:
		target_y = indicator_down.position.y
	elif input_direction.y < 0:
		target_y = indicator_up.position.y
	
	if target_x != cam_x or target_y != cam_y:
		var cam_movement
		
		cam_movement = get_tree().create_tween()
		cam_movement.set_ease(Tween.EASE_IN_OUT)
		cam_movement.set_trans(Tween.TRANS_SINE)
		
		cam_x = target_x
		cam_y = target_y
		
		cam_movement.tween_property(cam, "position", Vector2(cam_x, cam_y), easing)
func _finished(winner : Player):
	var tweener = get_tree().create_tween()
	tweener.set_ease(Tween.EASE_OUT)
	tweener.set_trans(Tween.TRANS_EXPO)
	tweener.tween_property(self, "position", winner.position, 1.5)
	
	pass
