extends StaticBody2D

var direction = 0
var speed = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	$AnimatedSprite2D.animation = str(GlobalScript.player_attributes.get(GlobalScript.peer_ID).get("Costume"))
	
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	
	#$Area2D.monitoring = true

func _process(delta):
	position.x += speed * direction 


func _on_area_2d_body_entered(body):
	if body.is_class("CharacterBody2D"):
		body.velocity.x = 500 * direction
		body.velocity.y = -250
	
	queue_free()
 
