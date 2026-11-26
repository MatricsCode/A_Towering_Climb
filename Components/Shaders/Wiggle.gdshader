shader_type canvas_item;

uniform float position_x = 1.0;
uniform float position_y = 1.0;
uniform float offset_x = 1.0;
uniform float offset_y = 1.0;

void vertex() {
	VERTEX.x += (sin(TIME * offset_x) * position_x);
	VERTEX.y += (cos(TIME * offset_y) * position_y);
}

void fragment() {
	//pass
}