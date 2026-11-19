extends Ability

const WINDUP_MAX := 3
const COLLISION_POSITION := Vector2(100,100)

enum States {WINDING_UP, PUNCHING, HIT, FLYING, NOTHING}

var punch_states := States.NOTHING
var punch_timer : Timer
var punch_area : Area2D

var windup_level := 0
var windup_time := 0.3
var punch_strength : int = 50

func _ready():
	punch_timer = Timer.new()
	add_child(punch_timer)
	punch_timer.timeout.connect(_punch_timeout)
	
	punch_area = Area2D.new()
	add_child(punch_area)
	
	punch_area.body_entered.connect(_punch_entered)
	punch_area.body_exited.connect(_punch_exited)

func _physics_process(delta):
	

func _punch_timeout():
	if windup_level < WINDUP_MAX:
		windup_level += 1
		punch_timer.start(windup_time)
		#sprite.play(str("windup", windup_level))
func _punch_entered(body : Player):
	pass
func _punch_exited(body : Player):
	pass
