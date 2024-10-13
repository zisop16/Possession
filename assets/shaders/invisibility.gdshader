
shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec3 invisibility_color: source_color;



void fragment() {
	vec2 dimensions = 1./SCREEN_PIXEL_SIZE;
	float ratio = dimensions.x / dimensions.y;
	
	vec4 inputColor = textureLod(screen_texture, SCREEN_UV, 0.0);
	COLOR = inputColor * vec4(invisibility_color, 1);
}