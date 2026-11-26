shader_type canvas_item;

uniform float position_x;
uniform float position_y;

void vertex() {
	VERTEX.x += (sin(TIME * 2.0) * position_x);
	VERTEX.y += (cos(TIME) * position_y);
}

void fragment() {
	//pass
}