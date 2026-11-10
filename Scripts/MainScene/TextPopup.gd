extends Node2D

const MAIN_THEME = preload("uid://cdqnrw5rcouf5")

func _ready():
	Signals.text_popup.connect(_spawn_text)

func _spawn_text(text : String, text_position : Vector2):
	var text_effect = Label.new()
	
	#var text_effect = RichTextLabel.new()
	#text_effect.add_theme_font_size_override("normal_font_size", 16)
	#text_effect.fit_content = true
	#text_effect.scroll_active = false
	#text_effect.autowrap_mode = TextServer.AUTOWRAP_OFF
	#text_effect.bbcode_enabled = true
	
	add_child(text_effect)
	
	text_effect.text = text
	text_effect.position = text_position
