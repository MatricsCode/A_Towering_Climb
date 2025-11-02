extends Control

@onready var sprite = $HSplitContainer/Control/AnimatedSprite2D

@onready var selector_ui = $"../SelectorUI"

var current_outfit = 0

func _physics_process(delta):
	if get_tree().get_node_count_in_group("PlayerOutfit") != 0 and current_outfit != -1:
		
		await get_tree().create_timer(5)
			
		for i in current_outfit:
			get_tree().call_group("PlayerOutfit", "switch_costume")
			
			current_outfit -= 1
		
		current_outfit = -1

func _on_climber_1_pressed():
	var current_frame = sprite.frame
	
	current_outfit = 0
	
	sprite.sprite_frames = GlobalScript.player_outfits[current_outfit]
	sprite.animation = "walk"
	sprite.play()
	sprite.frame = current_frame

func _on_climber_2_pressed():
	var current_frame = sprite.frame
	
	current_outfit = 1
	
	sprite.sprite_frames = GlobalScript.player_outfits[current_outfit]
	sprite.animation = "walk"
	sprite.play()
	sprite.frame = current_frame


func _on_exit_pressed():
	visible = false
	selector_ui.visible = true
