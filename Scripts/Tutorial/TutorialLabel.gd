extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		i.visible = false
	$Label5.visible = true

func _physics_process(_delta):
	if Input.is_action_just_pressed("P1_Interact") or Input.is_action_just_pressed("P2_Interact"):
		for i in get_children():
			i.visible = true
		$Label5.visible = false
