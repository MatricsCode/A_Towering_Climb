extends Camera2D

@onready var player_selector_spawner = $PlayerSelectorSpawner
@onready var container = $CanvasLayer/Container
@onready var background = $Background

var target_position = 0
var started = false

var sin_number = 0

func _ready():
	Signals.start.connect(has_started)
	#
	target_position = position.y
	position.y = 0
	
	make_current()
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(position.x, target_position), GlobalScript.countdown_timer)
	
	await tween.step_finished
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(position.x, -1620.0), 0.1)
	
	await tween.step_finished
	started = true
	
	player_selector_spawner._start()
	
	$Background.visible = true
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "zoom", Vector2(0.5, 0.5), 2)

func _physics_process(delta):
	var PosX = position.x - 1152.0 
	var PosY = position.y - 648.0
	
	container.position = Vector2(PosX,PosY)
	
	if started == true:
		if position.y == -1620.0:
			var tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(self, "position", Vector2(position.x, target_position), 30)
			
		elif position.y == target_position:
			var tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(self, "position", Vector2(position.x, -1620.0), 30)

func has_started(data):
	started = true
