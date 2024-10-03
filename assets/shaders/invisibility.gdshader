// Based on: https://www.shadertoy.com/view/Ms23DR
shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void fragment() {
	vec4 input_color = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec4 invisibility = vec4(.8, .8, 1.0, 1.0);
	COLOR = input_color * invisibility;
}