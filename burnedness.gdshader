shader_type spatial;

uniform sampler2D color_map;

varying float burnedness;

void vertex() {
	burnedness = CUSTOM0.r;
}

void fragment() {
	ALBEDO = texture(color_map, vec2(clamp(2.1*burnedness, 0.01, 4.99), 0.5)).rgb;
	ALPHA = clamp(burnedness, 0.0, 0.99);
}
