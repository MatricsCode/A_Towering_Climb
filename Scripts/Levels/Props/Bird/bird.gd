extends Node2D
class_name Bird

const BIRD_SPRITE_FRAMES = preload("uid://boimcwbblrhxc")
const COLORS = ["Blue", "Green", "Red"]

var nodes = {"sprite" : AnimatedSprite2D, "area" : Area2D, 
	"ray_cast" : RayCast2D, "hop_timer" : Timer}
var flying_vars = {"direction" = 0, "speed" = 10.0, "degrees" = 5.0, "count" = 0.0, "is_flying" = false}
var hopping_vars = {"direction" = 0, "end_point" = Vector2.ZERO, "is_hopping" = false,
	"curve_peak" = Vector2.ZERO, "difference" = 0.0, "hop_time" = 0.5, "minTime" = 1.0, "maxTime" = 10.0}
var appearance = {"color" = ""}

func _ready():
#region This spawns and sets up all of the required nodes 
	
	# Here it spawns the sprite,the area2D and the hop_timer + sets them all up
	nodes["sprite"] = AnimatedSprite2D.new()
	nodes.get("sprite").speed_scale = 3
	nodes.get("sprite").sprite_frames = BIRD_SPRITE_FRAMES
	add_child(nodes.get("sprite"))
	
	nodes["area"] = Area2D.new()
	nodes.get("area").set_collision_layer_value(1, false)
	add_child(nodes.get("area"))
	
	nodes["hop_timer"] = Timer.new()
	nodes.get("hop_timer").one_shot = true
	add_child(nodes["hop_timer"])
	
	# Here it creates the collision shape and it's shape for the area 2D
	var collision_field = CollisionShape2D.new()
	var collision_shape = CircleShape2D.new()
	collision_shape.radius = 64.0
	collision_field.shape = collision_shape
	nodes.get("area").add_child(collision_field)
	
	# Here it creates a raycast to see were the floor is
	nodes["ray_cast"] = RayCast2D.new()
	add_child(nodes.get("ray_cast"))
	nodes.get("ray_cast").set_collision_mask_value(1, false)
	nodes.get("ray_cast").set_collision_mask_value(2, true)
	nodes.get("ray_cast").target_position.y = 50
	
	# Here it checks when the raycast is colliding and 
	# sets the birds position to the position of the floor
	while !nodes.get("ray_cast").is_colliding():
		await get_tree().create_timer(0.1).timeout
	position = nodes.get("ray_cast").get_collision_point()
	position.y -= 10
	
	# Here it sets up all of the signals
	nodes.get("area").body_entered.connect(_player_entered)
	nodes.get("area").body_exited.connect(_player_exited)
	nodes.get("hop_timer").timeout.connect(_hop_execute)
#endregion
	
	_setup_node(nodes.get("hop_timer"))
	
	# Here it sets up it's appearance
	appearance["color"] = COLORS[randi_range(0, COLORS.size()-1)]
	nodes.get("sprite").play(str(appearance["color"], "Idle"))

func _physics_process(_delta):
	if flying_vars.get("is_flying"):
		_flying()


func _player_entered(body : PhysicsBody2D):
	if body.position.x < position.x:
		flying_vars["direction"] = -1
	else:
		flying_vars["direction"] = 1
		nodes.get("hop_timer").stop()
	flying_vars["is_flying"] = true
func _player_exited(_body : PhysicsBody2D):
	pass
	#var ray_cast = RayCast2D.new()
	#add_child(ray_cast)
	#ray_cast.set_collision_mask_value(1, false)
	#ray_cast.set_collision_mask_value(2, true)
	#ray_cast.target_position.y = 100
	#await get_tree().create_timer(0.1).timeout
	#position = ray_cast.get_collision_point()
	#position.y -= 16
	#ray_cast.queue_free()

func _flying():
	flying_vars["count"] += 1
	position.y += flying_vars.get("degrees") * flying_vars.get("speed") * -1
	position.x += flying_vars.get("speed") * flying_vars.get("direction") + sin(flying_vars.get("count"))

func _hop_execute():
	nodes.get("sprite").play(str(appearance.get("color"), "Fly"))
	hopping_vars.set("direction", randi_range(-1,1))
	while hopping_vars.get("direction") == 0:
		hopping_vars.set("direction", randi_range(-1,1))
	if flying_vars.get("is_flying"):
		return
	
	await _hop_measure(randf_range(100.0,200.0))
	if flying_vars.get("is_flying"):
		return
	
	var tweener = get_tree().create_tween()
	tweener.set_ease(Tween.EASE_IN)
	tweener.set_trans(Tween.TRANS_SINE)
	tweener.tween_property(self, "position", hopping_vars.get("curve_peak"), hopping_vars.get("hop_time"))
	
	await tweener.finished
	if flying_vars.get("is_flying"):
		return
	tweener.kill()
	tweener = get_tree().create_tween()
	tweener.tween_property(self, "position", hopping_vars.get("end_point"), hopping_vars.get("hop_time"))
	_setup_node(nodes.get("hop_timer"))
	
	await tweener.finished
	nodes.get("ray_cast").position = Vector2.ZERO
	await get_tree().create_timer(0.1).timeout
	nodes.get("sprite").play(str(appearance.get("color"), "Idle"))
func _hop_measure(starting_position : float):
	nodes.get("ray_cast").position.x = starting_position * hopping_vars.get("direction")
	
	var new_position = Vector2.ZERO
	while new_position == Vector2.ZERO:
		await get_tree().create_timer(0.1).timeout
		if nodes.get("ray_cast").is_colliding():
			new_position = nodes.get("ray_cast").get_collision_point()
		else:
			nodes.get("ray_cast").position.x -= hopping_vars.get("direction") * 0.1
	
	new_position.y -= 10
	
	hopping_vars.set("end_point", new_position)
	
	var difference = (new_position.x - position.x)
	var curve_peak := Vector2.ZERO
	curve_peak.x = position.x + (difference / 2)
	curve_peak.y = difference if difference < 0 else difference * -1
	
	hopping_vars["curve_peak"] = curve_peak
	hopping_vars["difference"] = difference
	
	return true

func _setup_node(node : Node):
	if node == nodes.get("hop_timer"):
		node.wait_time = randf_range(hopping_vars.get("minTime"), hopping_vars.get("maxTime"))
		node.start()
