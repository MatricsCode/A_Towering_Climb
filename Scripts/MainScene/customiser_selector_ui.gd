extends Control

@onready var sprite = $CenterContainer/Sprite
@onready var button_container = $Button_container

var costumes = ["Climber1", "Climber2", "Baker", "Heinrich"]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in costumes:
		var button = Base_Button.new()
		
		button.text = i
		button.name = i
		button.func_parent = self
		
		button_container.add_child(button)
	
	var back_button = Base_Button.new()
	
	back_button.text = "Back"
	back_button.name = "Back"
	back_button.func_parent = self
	
	button_container.add_child(back_button)

func button_pressed(costume_name : String):
	if costume_name != "Back":
		sprite.play(str(costumes.find(costume_name)))
		GlobalScript.player_costume = costumes.find(costume_name)
	else:
		visible = false
		$"../SelectorUI".visible = true
