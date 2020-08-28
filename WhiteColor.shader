shader_type canvas_item;

uniform bool active = false;

void fragment () {
	vec4 previous_color = texture(TEXTURE, UV);
	if (active) {
		COLOR = vec4(1, 1, 1, previous_color.a);
	} else {
		COLOR = previous_color;
	}
}