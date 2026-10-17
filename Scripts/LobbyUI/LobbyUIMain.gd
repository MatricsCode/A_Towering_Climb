extends Node

var levels = [preload("uid://bb64cr50jmhs8"),
	preload("uid://c04puj7j1jrp"),
	preload("uid://cn8yrub2tv3vi"),]

func _ready():
	Signals.host_created.connect(_level_select)

func _level_select(_lobby_id):
	for i in levels:
		var level = i.instantiate()
		
		add_child(level)
