#[compute]
#version 450

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, r32f) uniform readonly image2D scalar_field;
layout(set = 0, binding = 1, rg32f) uniform writeonly image2D gradient_field;

float finite_difference(ivec2 coordinate, ivec2 direction) {
  float value = imageLoad(scalar_field, coordinate + direction).r;
  value -= imageLoad(scalar_field, coordinate).r;
  return value;
}

void main() {
    ivec2 coords = ivec2(gl_GlobalInvocationID.xy);
    vec2 value = vec2(0.0, 0.0);
    value.x = finite_difference(coords, ivec2(1, 0));
    value.y = finite_difference(coords, ivec2(0, 1));
    value *= 1000;

    imageStore(gradient_field, coords, vec4(value, 0.0, 1.0));
}
