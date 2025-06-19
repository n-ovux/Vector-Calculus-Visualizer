#[compute]
#version 450

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, r32f) uniform readonly image2D scalar_field;
layout(set = 0, binding = 1, rg32f) uniform writeonly image2D gradient_field;

void main() {
    ivec2 texel_coords = ivec2(gl_GlobalInvocationID.xy);
    float value = imageLoad(scalar_field, texel_coords).r;

    imageStore(gradient_field, texel_coords, vec4(value, value, value, 1.0));
}
