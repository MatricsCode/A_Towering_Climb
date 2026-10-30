extends MarginContainer


@export var vignette := TextureRect

var vignette_texture : GradientTexture2D
var vignette_gradient : Gradient
var vignette_gradient_offset := 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	_vignette_texture()
	vignette.texture = vignette_texture
	
	Signals.vignette.connect(func(tran_time : float, wait_time : float):
		_vignette_animation(tran_time, wait_time))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vignette_gradient.set_offset(1, vignette_gradient_offset)
	
	if Input.is_action_pressed("Dev1"):
		_vignette_animation(1,1)

func _vignette_texture():
	vignette_texture = GradientTexture2D.new()
	
	vignette_gradient = Gradient.new()
	
	
	vignette_gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
	vignette_gradient.add_point(0.0,Color.TRANSPARENT)
	vignette_gradient.add_point(1,Color.BLACK)
	
	vignette_gradient.remove_point(0)
	vignette_gradient.remove_point(0)
	
	vignette_texture.fill = GradientTexture2D.FILL_RADIAL
	vignette_texture.set_fill_from(Vector2(0.5,0.5))
	vignette_texture.gradient = vignette_gradient
	vignette_texture.width = get_window().size.x
	vignette_texture.height = get_window().size.y
func _vignette_animation(tran_time : float, wait_time : float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "vignette_gradient_offset", 0.0, tran_time)
	await tween.finished
	await get_tree().create_timer(wait_time).timeout
	tween.stop()
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "vignette_gradient_offset", 1.0, tran_time)
