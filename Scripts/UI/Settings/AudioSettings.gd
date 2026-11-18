extends VBoxContainer

@export_group("Slider")
@export var master : HSlider
@export var music : HSlider
@export var SFX : HSlider

@export_group("PlayerInput")
@export var master_text : LineEdit
@export var music_text : LineEdit
@export var SFX_text : LineEdit

func _ready():
	master.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	music.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	SFX.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	master_text.text = str(db_to_linear(AudioServer.get_bus_volume_db(0)))
	music_text.text = str(db_to_linear(AudioServer.get_bus_volume_db(1)))
	SFX_text.text = str(db_to_linear(AudioServer.get_bus_volume_db(2)))
	
	master.value_changed.connect(func(value : float):
		AudioServer.set_bus_volume_db(0, linear_to_db(value))
		master_text.text = str(value))
	music.value_changed.connect(func(value : float):
		AudioServer.set_bus_volume_db(1, linear_to_db(value))
		music_text.text = str(value))
	SFX.value_changed.connect(func(value : float):
		AudioServer.set_bus_volume_db(2, linear_to_db(value))
		SFX_text.text = str(value))
	
	master_text.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER
	music_text.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER
	SFX_text.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER
	
	master_text.text_changed.connect(func(new_text : String):
		var value = int(new_text)
		master.value = value
		AudioServer.set_bus_volume_db(0, linear_to_db(value)))
	music_text.text_changed.connect(func(new_text : String):
		var value = int(new_text)
		music.value = value
		AudioServer.set_bus_volume_db(0, linear_to_db(value)))
	SFX_text.text_changed.connect(func(new_text : String):
		var value = int(new_text)
		SFX.value = value
		AudioServer.set_bus_volume_db(0, linear_to_db(value)))
