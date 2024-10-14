shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

uniform float contrast: hint_range(0, 3) = 1;
uniform float brightness: hint_range(-1, 1) = 0;
uniform float saturation: hint_range(0, 3) = 1;
uniform float gamma: hint_range(0, 3) = 1;
uniform float exposure: hint_range(0, 3) = 1;
uniform vec3 filter: source_color = vec3(1, 1, 1);

void fragment() {
	vec4 inputColor = textureLod(screen_texture, SCREEN_UV, 0.);
	vec3 color = inputColor.rgb;
	color *= exposure;
	color = clamp(color, 0, 1);
	color = contrast * (color - .5) + .5 + brightness;
	color = clamp(color, 0, 1);
	color *= filter;
	
	vec3 grayscaleVector = vec3(.299, .587, .114);
	float grayscale = dot(color, grayscaleVector);
	color = saturation * color + (1.-saturation) * grayscale;
	color = clamp(color, 0, 1);
	
	color = pow(color, vec3(1./gamma));
	
	COLOR = vec4(color, inputColor.a);
}