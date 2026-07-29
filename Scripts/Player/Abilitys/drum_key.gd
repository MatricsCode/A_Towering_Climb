extends abilitys

var interactable
var area

func _ready():
	var scanner = Area2D.new()
	
	scanner.body_entered.connect(interact)
	scanner.body_exited.connect(interact)
	
	var hit_area = CollisionShape2D.new()
	
	hit_area.shape = RectangleShape2D.new()
	hit_area.position.y -= 50
	hit_area.debug_color = Color.BLACK
	
	add_child(scanner)
	
	area = get_child(0)
	
	scanner.set_collision_mask_value(1, false)
	scanner.set_collision_layer_value(1, false)
	
	scanner.set_collision_mask_value(24, true)
	
	scanner.add_child(hit_area)

func _physics_process(delta):
	if area != null:
		area.position = player.position
	
	if interactable != null and Input.is_action_pressed("Ability"):
		interactable.interact(self)

func interact(body):
	if interactable == null:
		interactable = body
		body.entered(true)
	else:
		interactable = null
		body.entered(false)
