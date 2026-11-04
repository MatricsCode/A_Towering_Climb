extends Control

@export var character_selector : Control

@export var debug_label : Label
@export var main_ability_label : Label
@export var passive_ability_label : Label
@export var quit_button : HoverButton

func _ready():
	quit_button.pressed.connect(func():
		get_tree().quit())
	
	Signals.debug.connect(func(is_debug):
		visible = is_debug
		
		var text1 = str(character_selector.players.get(0).main_ability).split(":")
		text1 = text1[1]
		text1 = text1.split("/")
		text1 = text1[text1.size()-1]
		text1 = text1.split(".")
		text1 = text1[0]
		var text2 = str(character_selector.players.get(0).passive_ability).split(":")
		text2 = text2[1]
		text2 = text2.split("/")
		text2 = text2[text2.size()-1]
		text2 = text2.split(".")
		text2 = text2[0]
		
		debug_label.text = "Debug"
		main_ability_label.text = text1
		passive_ability_label.text = text2)
	
	visible = false
	
	debug_label.visible = true
	main_ability_label.visible = true
	passive_ability_label.visible = true
	quit_button.visible = true
