extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	add_indicator(self, GlobalScript.player_outfits[0])
	
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://Art/Sandwich/Sandwich1.png")
	add_child(sprite)
	add_child(Container.new())
	
	for i in GlobalScript.player_outfits.size() -1:
		add_indicator(get_child(2), GlobalScript.player_outfits[i + 1])

func add_indicator(parent : Node, outfit : int):
	var indicator = VSlider.new()
	
	indicator.theme = GlobalScript.all_player_outfits[outfit]
