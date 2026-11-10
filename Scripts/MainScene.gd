extends Control

const PLAYER_CAMERA = preload("uid://n84h7ds41dm6")

var screen_size = Vector2(1152, 648)

@export_group("Containers")
@export var main_container : VBoxContainer

@export var container_1 : HBoxContainer
@export var container_2 : HBoxContainer

@export_group("Viewports")
@export_subgroup("Viewport_Containers")
@export var viewport_container_1 : SubViewportContainer
@export var viewport_container_2 : SubViewportContainer
@export var viewport_container_3 : SubViewportContainer
@export var viewport_container_4 : SubViewportContainer

@export_subgroup("Viewports")
@export var viewport_1 : SubViewport
@export var viewport_2 : SubViewport
@export var viewport_3 : SubViewport
@export var viewport_4 : SubViewport

var camera1 : Node2D
var camera2 : Node2D
var camera3 : Node2D
var camera4 : Node2D

const GAME_SCENE = preload("uid://bvgxox4xf14tm")

func _ready():
	Signals.lobby_joined.connect(func(_ID): main_container.visible = true)
	Signals.lobby_left.connect(func(_ID): main_container.visible = false)
	
	Signals.player_created.connect(_player_added)
	Signals.player_deleted.connect(_player_removed)
	
	viewport_1.size = screen_size
	viewport_container_1.size = screen_size
	
	viewport_1.world_2d = $SubViewportContainer/SubViewport.world_2d
	viewport_2.world_2d = $SubViewportContainer/SubViewport.world_2d
	viewport_3.world_2d = $SubViewportContainer/SubViewport.world_2d
	viewport_4.world_2d = $SubViewportContainer/SubViewport.world_2d
	
	camera1 = PLAYER_CAMERA.instantiate()
	camera2 = PLAYER_CAMERA.instantiate()
	camera3 = PLAYER_CAMERA.instantiate()
	camera4 = PLAYER_CAMERA.instantiate()
	
	viewport_1.add_child(camera1)
	viewport_2.add_child(camera2)
	viewport_3.add_child(camera3)
	viewport_4.add_child(camera4)


func _player_added(player : Player):
	var local_players = GlobalScript.players[Steam.getSteamID()]
	
	match local_players.size():
		1:
			_mono_player(player)
		2:
			_duo_player(player)#
		3:
			_tri_player(player)
		4:
			_quad_player(player)
func _player_removed(player : Player):
	match GlobalScript.players.get(Steam.getSteamID()).size():
		1:
			_mono_player(player)
		2:
			_duo_player(player)
		3:
			_tri_player(player)
		4:
			_quad_player(player)

func _switch():
	_mono_player(null)
	await get_tree().create_timer(5).timeout
	_duo_player(null)
	await get_tree().create_timer(5).timeout
	_tri_player(null)
	await get_tree().create_timer(5).timeout
	_quad_player(null)
	await get_tree().create_timer(5).timeout
	_switch()

func _mono_player(player : Player):
	container_1.visible = true
	container_2.visible = false
	
	viewport_container_1.visible = true
	viewport_container_2.visible = false
	viewport_container_3.visible = false
	viewport_container_4.visible = false
	
	viewport_1.size = screen_size
	
	camera1.player = player
	
	camera1.current_state = camera1.States.FOLLOWING_PLAYER
	camera2.current_state = camera2.States.OVERIDDEN
	camera3.current_state = camera3.States.OVERIDDEN
	camera4.current_state = camera4.States.OVERIDDEN
func _duo_player(player : Player):
	container_1.visible = true
	container_2.visible = false
	
	viewport_container_1.visible = true
	viewport_container_2.visible = true
	viewport_container_3.visible = false
	viewport_container_4.visible = false
	
	viewport_1.size = Vector2(screen_size.x/2,screen_size.y)
	viewport_2.size = Vector2(screen_size.x/2,screen_size.y)
	
	camera2.player = player
	
	camera1.current_state = camera1.States.FOLLOWING_PLAYER
	camera2.current_state = camera2.States.FOLLOWING_PLAYER
	camera3.current_state = camera3.States.OVERIDDEN
	camera4.current_state = camera4.States.OVERIDDEN
func _tri_player(player : Player):
	container_1.visible = true
	container_2.visible = true
	
	viewport_container_1.visible = true
	viewport_container_2.visible = true
	viewport_container_3.visible = true
	viewport_container_4.visible = false
	
	viewport_1.size = Vector2(screen_size.x/2,screen_size.y/2)
	viewport_2.size = Vector2(screen_size.x/2,screen_size.y/2)
	viewport_3.size = Vector2(screen_size.x,screen_size.y/2)
	
	camera3.player = player
	
	camera1.current_state = camera1.States.FOLLOWING_PLAYER
	camera2.current_state = camera2.States.FOLLOWING_PLAYER
	camera3.current_state = camera3.States.FOLLOWING_PLAYER
	camera4.current_state = camera4.States.OVERIDDEN
func _quad_player(player : Player):
	container_1.visible = true
	container_2.visible = true
	
	viewport_container_1.visible = true
	viewport_container_2.visible = true
	viewport_container_3.visible = true
	viewport_container_4.visible = true
	
	viewport_1.size = Vector2(screen_size.x/2,screen_size.y/2)
	viewport_2.size = Vector2(screen_size.x/2,screen_size.y/2)
	viewport_3.size = Vector2(screen_size.x/2,screen_size.y/2)
	viewport_4.size = Vector2(screen_size.x/2,screen_size.y/2)
	
	camera4.player = player
	
	camera1.current_state = camera1.States.FOLLOWING_PLAYER
	camera2.current_state = camera2.States.FOLLOWING_PLAYER
	camera3.current_state = camera3.States.FOLLOWING_PLAYER
	camera4.current_state = camera4.States.FOLLOWING_PLAYER
