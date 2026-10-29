extends Node2D

@export var player_node : Node2D
@export var item_node : Node2D
@export var win_node : Node2D

@export var indicator_up : Node2D
@export var indicator_down : Node2D
@export var indicator_left : Node2D
@export var indicator_right : Node2D

@onready var cam = $Camera2D

enum States {BOUNCING, STARTING_ANIMATION, FOLLOWING_PLAYER, FINISHED}
var current_state := States.BOUNCING

var bouncing_time = 0

var easing :float = 1.0

var cam_x : float = 0
var cam_y : float = 0

var player : Player = null
var viewing_player : Player = null

var move_time : float = 5.0
var zoom_time : float = 20.0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = States.BOUNCING
	
	
	Signals.lobby_start_game.connect(_start_animation)
	Signals.lobby_finished_game.connect(func(winner : Player):
		current_state = States.FINISHED
		viewing_player = winner
		_finished())

func _physics_process(_delta):
	if Input.is_action_just_pressed("Dev1"):
		Signals.vignette.emit(1, 1)
	
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
	current_state = States.STARTING_ANIMATION
	var start_anim : Tween
	
	#start_anim = get_tree().create_tween()
	#start_anim.set_parallel()
	#start_anim.set_ease(Tween.EASE_OUT)
	#start_anim.tween_property(self, "position", Vector2(0, -7000), 2)
	#start_anim.tween_property(cam, "zoom", Vector2(0.2, 0.2), 2)
	#
	#await get_tree().create_timer(2.5).timeout
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
	start_anim.tween_property(cam, "zoom", Vector2(0.6,0.6), 2)
	
	await start_anim.finished
	
	if !get_parent().is_class("Player"):
		for finding_player in player_node.get_children():
			if finding_player is CharacterBody2D:
				if finding_player.player_source.steam_ID == Steam.getSteamID():
					player = finding_player
	
	current_state = States.FOLLOWING_PLAYER
func _following_player():
	position = player.position
	
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	var target_x : float = 0
	var target_y : float = 0
	
	if input_direction.x == 0:
		target_x = 0
	elif input_direction.x > 0:
		target_x = indicator_right.position.x
	elif input_direction.x < 0:
		target_x = indicator_left.position.x
	
	if input_direction.y == 0:
		target_y = 0
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
func _finished():
	var _return_tween := func():
		var tweener = get_tree().create_tween()
		
		tweener.set_parallel()
		tweener.set_ease(Tween.EASE_OUT)
		tweener.set_trans(Tween.TRANS_SINE)
		
		return tweener
	
	var _movement_anim := func():
		var tweener = _return_tween.call()
		
		tweener.tween_property(self, "position", Vector2.ZERO, move_time/2)
		tweener.tween_property(cam, "zoom", Vector2(0.1, 0.1), move_time/2)
		tweener.tween_property(cam, "position", Vector2(0,0), move_time/2)
		
		await tweener.finished
		var tweener2 = _return_tween.call()
		
		tweener2.tween_property(self, "position", viewing_player.position, move_time/2)
		tweener2.tween_property(cam, "zoom", Vector2(1 ,1), move_time/2)
		
		await tweener2.finished
		
		return
	var _zoom_anim := func():
		var tweener = _return_tween.call()
		
		tweener.tween_property(cam, "position", indicator_up.position, zoom_time/5.0)
		await tweener.finished
		tweener = _return_tween.call()
		tweener.tween_property(cam, "position", indicator_left.position, zoom_time/5.0)
		await tweener.finished
		tweener = _return_tween.call()
		tweener.tween_property(cam, "position", indicator_down.position, zoom_time/5.0)
		await tweener.finished
		tweener = _return_tween.call()
		tweener.tween_property(cam, "position", indicator_right.position, zoom_time/5.0)
		await tweener.finished
		tweener = _return_tween.call()
		tweener.tween_property(cam, "position", Vector2.ZERO, zoom_time/5.0)
		await tweener.finished
		
		return
	
	await _movement_anim.call()
	await _zoom_anim.call()
	
	var index = viewing_player.get_index() + 1
	if index > player_node.get_child_count()-1:
		index = 1
	viewing_player = player_node.get_child(index)
	
	if current_state == States.FINISHED:
		_finished()
