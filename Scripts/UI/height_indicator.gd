extends HBoxContainer

@onready var objects = $Objects
@onready var map = $Map
@onready var players = $Players

var main_theme = preload("res://Recourses/UI/main.tres")

var p1 = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3.1).timeout
	for i in GlobalScript.important_positions.keys():
		add_indicator(objects, GlobalScript.important_positions[i])
		
		var index = GlobalScript.important_positions.keys()
		objects.get_child(objects.get_child_count() -1).value = i.y * -1
	
	for i in GlobalScript.player_positions.keys():
		if p1 == "":
			p1 = i
			add_indicator(objects, GlobalScript.player_positions.get(i)[0] * -1, p1)
		else:
			add_indicator(players, GlobalScript.player_positions.get(i)[0] * -1, i)

func _physics_process(delta):
	if p1 != "":
		objects.get_child(objects.get_child_count() -1).value = GlobalScript.player_positions.get(p1)[1].y * -1
		
		for i in players.get_children():
			i.value = GlobalScript.player_positions.get(i.get_index())[0] * -1
			print(i.value)

func add_indicator(parent : Node, outfit, _name = ""):
	
	var level_height = 0
	for i in GlobalScript.important_positions.keys():
		if GlobalScript.important_positions.get(i) == 4:
			level_height = i.y * -1
	
	print(level_height)
	
	var indicator = VSlider.new()
	
	indicator.set_anchors_preset(Control.PRESET_FULL_RECT)
	indicator.min_value = 0
	indicator.max_value = level_height + 100
	
	indicator.theme = main_theme
	
	indicator.add_theme_icon_override("grabber", GlobalScript.markers[outfit])
	indicator.add_theme_stylebox_override("grabber_area", StyleBoxEmpty.new())
	
	parent.add_child(indicator)
