extends Control

@onready var sprite = $HSplitContainer/Control/AnimatedSprite2D

@onready var selector_ui = $"../SelectorUI"

const CLIMBER_1 = preload("res://Recourses/PlayerSprites/Climber1.tres")
const CLIMBER_2 = preload("res://Recourses/PlayerSprites/Climber2.tres")

func _on_climber_1_pressed():
	var current_frame = sprite.frame
	
	sprite.sprite_frames = CLIMBER_1
	sprite.animation = "walk"
	sprite.play()
	sprite.frame = current_frame
	
	GlobalScript.current_outfit = CLIMBER_1

func _on_climber_2_pressed():
	var current_frame = sprite.frame
	
	sprite.sprite_frames = CLIMBER_2
	sprite.animation = "walk"
	sprite.play()
	sprite.frame = current_frame
	
	GlobalScript.current_outfit = CLIMBER_2


func _on_exit_pressed():
	visible = false
	selector_ui.visible = true
