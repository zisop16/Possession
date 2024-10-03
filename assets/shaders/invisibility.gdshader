// Based on: https://www.shadertoy.com/view/Ms23DR
shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec3 invisibilityColor: source_color;

void fragment() {
	vec4 inputColor = textureLod(screen_texture, SCREEN_UV, 0.0);
	COLOR = inputColor * vec4(invisibilityColor, 1.0);
}