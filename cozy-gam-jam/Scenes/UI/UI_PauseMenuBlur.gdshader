shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;
uniform float blur_amount : hint_range(0.0, 10.0) = 3.0;

void fragment() {
	vec2 size = SCREEN_PIXEL_SIZE * blur_amount;
	vec4 color = vec4(0.0);
	
	// Échantillonnage en grille pour créer un flou gaussien sur la scène 3D
	color += texture(screen_texture, SCREEN_UV + vec2(-size.x, -size.y)) * 0.0625;
	color += texture(screen_texture, SCREEN_UV + vec2(0.0, -size.y)) * 0.125;
	color += texture(screen_texture, SCREEN_UV + vec2(size.x, -size.y)) * 0.0625;
	
	color += texture(screen_texture, SCREEN_UV + vec2(-size.x, 0.0)) * 0.125;
	color += texture(screen_texture, SCREEN_UV + vec2(0.0, 0.0)) * 0.25;
	color += texture(screen_texture, SCREEN_UV + vec2(size.x, 0.0)) * 0.125;
	
	color += texture(screen_texture, SCREEN_UV + vec2(-size.x, size.y)) * 0.0625;
	color += texture(screen_texture, SCREEN_UV + vec2(0.0, size.y)) * 0.125;
	color += texture(screen_texture, SCREEN_UV + vec2(size.x, size.y)) * 0.0625;
	
	COLOR = color * COLOR;
}