shader_type canvas_item;

uniform sampler2D mask_texture;
uniform vec3 mask_color = vec3(0,0,0);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 mask = texture(mask_texture, UV);

	color.a = mask.r;
	color.rgb = mask_color;

	COLOR = color;
}
