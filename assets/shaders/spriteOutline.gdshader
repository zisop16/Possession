shader_type canvas_item;

uniform vec3 outline_color: source_color;
uniform float outline_width: hint_range(0.0, 0.01, 0.0001) = .001;

void fragment() {
	vec2 left = vec2(UV.x - outline_width, UV.y);
	vec2 right = vec2(UV.x + outline_width, UV.y);
	vec2 up = vec2(UV.x, UV.y + outline_width);
	vec2 down = vec2(UV.x, UV.y - outline_width);
	
	vec4 leftColor = texture(TEXTURE, left);
	vec4 rightColor = texture(TEXTURE, right);
	vec4 upColor = texture(TEXTURE, up);
	vec4 downColor = texture(TEXTURE, down);
	
	bool currentlyColored = COLOR.a != 0.;
	bool horizBorder = (leftColor.a == 0. && rightColor.a != 0.) || (leftColor.a != 0. && rightColor.a == 0.);
	bool vertBorder = (upColor.a == 0. && downColor.a != 0.) || (upColor.a != 0. && downColor.a == 0.);
	
	if (!currentlyColored && (horizBorder || vertBorder)) {
		COLOR = vec4(outline_color, 1);
	}
	
}
