shader_type canvas_item;

uniform sampler2D gradient;

void fragment() {
  float value = texture(TEXTURE, UV).r;

  COLOR = texture(gradient, vec2(value, 0.0));
}
