extends Control
var screen_size = Vector2(1152, 648)

@export var container_1 : HBoxContainer
@export var container_2 : HBoxContainer

@export var viewport_container_1 : SubViewportContainer
@export var viewport_container_2 : SubViewportContainer
@export var viewport_container_3 : SubViewportContainer
@export var viewport_container_4 : SubViewportContainer

@export var viewport_1 : SubViewport
@export var viewport_2 : SubViewport
@export var viewport_3 : SubViewport
@export var viewport_4 : SubViewport

const GAME_SCENE = preload("uid://bvgxox4xf14tm")

func _ready():
	
	viewport_1.size = screen_size
	viewport_container_1.size = screen_size
	
	viewport_1.world_2d = $SubViewport.world_2d
	viewport_2.world_2d = $SubViewport.world_2d
	viewport_3.world_2d = $SubViewport.world_2d
	viewport_4.world_2d = $SubViewport.world_2d

func _mono_player():
	container_1.visible = true
	container_2.visible = false
	
	viewport_container_1.visible = true
	viewport_container_2.visible = false
	viewport_container_3.visible = false
	viewport_container_4.visible = false
func _duo_player():
	pass
func _tri_player():
	pass
func _quad_player():
	pass
