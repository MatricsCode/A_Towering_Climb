extends StaticBody2D

@export var speed := 1

@export var position1 := Vector2.ZERO
@export var position2 := Vector2.ZERO

var chosen_position = Vector2.ZERO

@onready var label = $Label

var player = null

var players = []

func _ready():
	position = position1

func _physics_process(_delta):
	if Input.is_action_just_pressed("Interact") and label.visible == true:
		player.position = position
		label.visible = false
		move()

func _on_area_2d_body_entered(body):
	var key_search = body.get_children(true)
	
	var key = GlobalScript.all_player_abilitys.keys()
	
	for i in key_search:
		
		var children = i.get_children(true) 
		
		for y in children:
			if y.name == key[1]:
				label.visible = true
				if body.is_multiplayer_authority():
					player = body
			else:
				pass

func _on_area_2d_body_exited(_body):
	label.visible = false
	player = null

func move():
	if position == position1:
		tween(position2, self)
		tween(position2, player)
	elif position == position2:
		tween(position1, self)
		tween(position1, player)

func tween(pos, user):
	var position_change = create_tween()
	position_change.tween_property(user, "position", pos, speed)
