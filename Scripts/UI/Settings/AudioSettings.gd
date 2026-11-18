extends VBoxContainer

@export var master : HSlider
@export var music : HSlider
@export var master_SFX : HSlider
@export var player_SFX : HSlider
@export var other_SFX : HSlider

func _ready():
	master.value_changed.connect(func(value : float):
		print(value))
	music.value_changed.connect(func(value : float):
		print(value))
	master_SFX.value_changed.connect(func(value : float):
		print(value))
	player_SFX.value_changed.connect(func(value : float):
		print(value))
	other_SFX.value_changed.connect(func(value : float):
		print(value))
	
