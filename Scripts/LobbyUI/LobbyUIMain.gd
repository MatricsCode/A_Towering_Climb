extends Node

var levels = [preload("uid://cn8yrub2tv3vi")] #[preload("uid://bb64cr50jmhs8"),
	#preload("uid://c04puj7j1jrp"),
	#preload("uid://cn8yrub2tv3vi"),]

func _ready():
	Signals.lobby_start_game.connect(_level_select)

func _level_select():
	var level_number = levels[randi_range(0, levels.size()-1)]
	var level = level_number.instantiate()
	
	add_child(level)
