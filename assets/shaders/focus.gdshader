
shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
// UV coordinates of focus target
uniform vec2 focus = vec2(0, 0);



void fragment() {
	vec2 dimensions = 1./SCREEN_PIXEL_SIZE;
	float ratio = dimensions.x / dimensions.y;

	vec4 inputColor = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec2 diff = SCREEN_UV - focus;
	diff.x *= ratio;
	float distSq = dot(diff, diff);
	float blackFactor = 65.;
	float lowerBound = .01;
	float lightness = 2. * (1. - (1. - lowerBound) / (1. + pow(2, -blackFactor * distSq)));
	inputColor.xyz *= lightness;

	COLOR = inputColor;
}