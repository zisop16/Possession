shader_type canvas_item;

uniform vec3 outline_color: source_color;
uniform float outline_width: hint_range(0.0, 0.01, 0.0001) = .001;
uniform vec2 spritesheet_dimensions = vec2(1, 1);
uniform vec2 spritesheet_coords = vec2(0, 0);

void fragment() {
	vec2 left = vec2(UV.x - outline_width, UV.y);
	vec2 right = vec2(UV.x + outline_width, UV.y);
	vec2 up = vec2(UV.x, UV.y + outline_width);
	vec2 down = vec2(UV.x, UV.y - outline_width);
	
	float lowerX = spritesheet_coords.x / spritesheet_dimensions.x;
	float upperX = (spritesheet_coords.x + 1.) / spritesheet_dimensions.x;
	float lowerY = spritesheet_coords.y / spritesheet_dimensions.y;
	float upperY = (spritesheet_coords.y + 1.) / spritesheet_dimensions.y;
	vec2 lower = vec2(lowerX, lowerY);
	vec2 upper = vec2(upperX, upperY);
	left = clamp(left, lower, upper);
	right = clamp(right, lower, upper);
	up = clamp(up, lower, upper);
	down = clamp(down, lower, upper);
	
	vec4 leftColor = texture(TEXTURE, left);
	vec4 rightColor = texture(TEXTURE, right);
	vec4 upColor = texture(TEXTURE, up);
	vec4 downColor = texture(TEXTURE, down);
	
	bool onBorder = COLOR.a == 0. && (leftColor.a != 0. || rightColor.a != 0. || upColor.a != 0. || downColor.a != 0.);
	
	
	if (onBorder) {
		COLOR = vec4(outline_color, 1);
	}
	
}
