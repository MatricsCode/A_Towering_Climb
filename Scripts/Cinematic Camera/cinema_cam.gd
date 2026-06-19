extends Camera2D

@onready var player_selector_spawner = $PlayerSelectorSpawner
@onready var container = $Container

var target_position = 0
var started = false

var sin_number = 0

func _ready():
	target_position = position.y
	print(target_position)
	position.y = 0
	
	make_current()
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, target_position), 1).set_ease(Tween.EASE_IN_OUT)
	
	await tween.step_finished
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x, -1620.0), GlobalScript.countdown_timer).set_ease(Tween.EASE_IN_OUT)
	
	await tween.step_finished
	started = true
	
	player_selector_spawner.start()
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(0.5, 0.5), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func _physics_process(delta):
	
	var PosX = position.x - 1152.0 
	var PosY = position.y - 648.0
	
	container.position = Vector2(PosX,PosY)
	
	if started == true:
		if position.y == -1620.0:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "position", Vector2(position.x, target_position), 30).set_ease(Tween.EASE_IN_OUT)
			
		elif position.y == target_position:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "position", Vector2(position.x, -1620.0), 30).set_ease(Tween.EASE_IN_OUT)
