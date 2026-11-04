extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)

func _body_entered(body : Player):
	if body.
func _body_exited(body : Player):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
