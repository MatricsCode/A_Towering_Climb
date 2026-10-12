extends Control

@onready var anim_open = $AnimationPlayerClose
@onready var anim_close = $AnimationPlayerOpen

func _change_ui(old_ui : String, new_ui : String):
	anim_close.play(str("Close_", old_ui))
	anim_open.play(str("Open_", new_ui))
