shader_type canvas_item;

uniform float speed = 1.0;

void vertex() {
	UV *= 1.5;
	UV -= vec2(TIME * speed / 10.0, 0.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
