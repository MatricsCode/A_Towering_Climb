extends VBoxContainer

@onready var control = $"../../.."
@onready var buttons = $SplitContainer/Buttons
@onready var indicators = $SplitContainer/Indicators
@onready var sprite = $"../Visualiser/sprite"

func _ready():
	for i in indicators.get_children():
		i.color = control.red
	
	indicators.get_child(0).color = control.green


func button_pressed(data):
	for i in indicators.get_children():
		if i.name == data:
			i.color = Color.GREEN
			control.costume = i.get_index()
			sprite.play(str(i.get_index()))
		else:
			i.color = control.red
