extends abilitys

var interactable

func _ready():
	var scanner = Area2D.new()
	scanner.body_entered.connect(activate)
	scanner.body_exited.connect(activate)
	
	scanner.set_collision_mask_value(0, false)
	scanner.set_collision_mask_value(23, true)
	
	var hit_area = CollisionShape2D.new()
	
	hit_area.position.y = -181.0
	hit_area.shape = RectangleShape2D.new()
	
	add_child(scanner)

func _physics_process(delta):
	if interactable != null and Input.is_action_pressed(input):
		interactable.action()

func activate(body):
	interactable = body
