extends MarginContainer

var main_abilities = {"Ram" : "res://Scripts/Abilitys/MainAbilities/Ram.gd",
	}
var passive_abilities = {"Glide" : "res://Scripts/Abilitys/SecondaryAbilities/Glide.gd", 
	"DrumKey" : "res://Scripts/Abilitys/SecondaryAbilities/DrumKey.gd"}

var current_main_ability := 0
var current_pass_ability := 0

@export var next_main : HoverButton
@export var last_main : HoverButton
@export var text_main : Label
@export var next_passive : HoverButton
@export var last_passive : HoverButton
@export var text_passive : Label

func _ready():
	next_main.pressed.connect(func(): 
		_main_ability(1))
	last_main.pressed.connect(func(): 
		_main_ability(-1))
	next_passive.pressed.connect(func(): 
		_passive_ability(1))
	last_passive.pressed.connect(func(): 
		_passive_ability(-1))
	var keys_main = main_abilities.keys()
	var keys_pass = passive_abilities.keys()
	text_main.text = keys_main[current_main_ability]
	text_passive.text = keys_pass[current_pass_ability]

func _main_ability(direction := 1):
	if (current_main_ability + direction) >= 0 and (current_main_ability + direction) < main_abilities.size():
		current_main_ability += direction
	elif (current_main_ability + direction) < 0:
		current_main_ability = main_abilities.size()-1
	elif (current_main_ability + direction) >= main_abilities.size():
		current_main_ability = 0
	
	var names = main_abilities.keys()
	text_main.text = names[current_main_ability]
func _passive_ability(direction := 1):
	if (current_pass_ability + direction) >= 0 and (current_pass_ability + direction) < passive_abilities.size():
		current_pass_ability += direction
	elif (current_pass_ability + direction) < 0:
		current_pass_ability = passive_abilities.size()-1
	elif (current_pass_ability + direction) >= passive_abilities.size():
		current_pass_ability = 0
	
	var names = passive_abilities.keys()
	text_passive.text = names[current_pass_ability]
