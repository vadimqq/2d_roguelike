shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform float size;
uniform float thickness;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaleUV = (UV - vec2(0.5, 0.0)) / vec2(1, 1) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size - 0.1, size, length(scaleUV - center))) * smoothstep(size - thickness - 0.1, size - thickness, length(scaleUV - center));
	vec2 disp = normalize(scaleUV - center) * force * mask;
//	COLOR = vec4(UV - disp, 0.0, 1.0);
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
}