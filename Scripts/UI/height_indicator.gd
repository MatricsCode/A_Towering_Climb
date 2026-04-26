extends HBoxContainer

@onready var objects = $Objects


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in GlobalScript.important_positions:
		add_indicator(objects, GlobalScript.important_positions[i])
	
	
	#var sprite = Sprite2D.new()
	#sprite.texture = load("res://Art/Sandwich/Sandwich1.png")
	#add_child(sprite)
	#add_child(Container.new())
	#
	#for i in GlobalScript.player_outfits.size() -1:
		#add_indicator(get_child(2), GlobalScript.all_player_outfits[GlobalScript.player_outfits[i + 1]])

func add_indicator(parent : Node, outfit):
	var indicator = VSlider.new()
	
	indicator.add_theme_icon_override("Slider", outfit)
	
	parent.add_child(indicator)
