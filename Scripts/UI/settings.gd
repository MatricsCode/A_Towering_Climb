extends VBoxContainer

var main_bus = AudioServer.get_bus_index("Master")
var player_bus = AudioServer.get_bus_index("Player")
var music_bus = AudioServer.get_bus_index("Music")
var background_bus = AudioServer.get_bus_index("Background")


func _on_main_value_changed(value_changed):
	AudioServer.set_bus_volume_db(main_bus, linear_to_db(value_changed))
	print(AudioServer.get_bus_volume_db(main_bus))

func _on_player_value_changed(value_changed):
	AudioServer.set_bus_volume_db(player_bus, linear_to_db(value_changed))

func _on_bg_sfx_value_changed(value_changed):
	AudioServer.set_bus_volume_db(background_bus, linear_to_db(value_changed))

func _on_music_value_changed(value_changed):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value_changed))
