shader_type canvas_item;
// credit: https://www.youtube.com/watch?v=Z2o6IfmK61A

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 5.0, 0.1) = 1.5;

void fragment() {
	vec3 result = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount).rgb;
	COLOR.rgb = result;
}