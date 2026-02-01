extends Panel

var main_screen
var main_player = false
var current_player : int


@onready var ready_button = $VBoxContainer/Ready
@onready var button_container = $VBoxContainer/ButtonContainer
@onready var animated_sprite_2d = $VBoxContainer/CenterContainer/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout
	
	if main_player == false:
		for i in button_container.get_children():
			i.text = "Other Player"
			i.disabled = true
		ready_button.text = "Someone elses!"
		ready_button.disabled

func _physics_process(delta):
	if animated_sprite_2d.animation != str(GlobalScript.player_outfits[current_player]):
		animated_sprite_2d.animation = str(GlobalScript.player_outfits[current_player])

func button_pressed(name):
	$VBoxContainer/CenterContainer/AnimatedSprite2D.play(name)
	
	for i in $VBoxContainer/ButtonContainer.get_children():
		if i.name == name:
			GlobalScript.player_outfits[current_player] = i.get_index()


func _on_ready_pressed():
	if ready_button.text == "Ready?":
		ready_button.text = "Geared Up!"
		
		for i in button_container.get_children():
			i.disabled = true
		
		main_screen.ready(true)
	
	elif ready_button.text == "Changed my mind...":
		ready_button.text = "Ready?"
		
		for i in button_container.get_children():
			i.disabled = false
		
		main_screen.ready(false)


func _on_ready_mouse_entered():
	if ready_button.text == "Geared Up!":
		ready_button.text = "Changed my mind..."


func _on_ready_mouse_exited():
	if ready_button.text == "Changed my mind...":
		ready_button.text = "Geared Up!"
