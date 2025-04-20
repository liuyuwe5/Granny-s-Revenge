shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.3, 1.0);
uniform float glow_strength = 0.5;
uniform float pulse_speed = 2.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);
	COLOR = tex + glow_color * pulse * glow_strength * tex.a;
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
