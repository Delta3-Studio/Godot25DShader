shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back,
            diffuse_toon, specular_toon, 
            shadows_disabled, ambient_light_disabled;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

uniform float roughness : hint_range(0.0, 1.0);
uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);
uniform float rim : hint_range(0.0, 1.0, 0.01);
uniform float rim_tint : hint_range(0.0, 1.0, 0.01);

uniform vec3 uv1_scale = vec3(1.0);
uniform vec3 uv1_offset;

#include "includes/depth_bias.gdshaderinc"
#include "includes/ortho_blend.gdshaderinc"

void vertex() {
    APPLY_VERTEX_ORTHO_BLEND
    applyDepthBias(POSITION);
    UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
    vec2 base_uv = UV;
    vec4 albedo_tex = texture(texture_albedo, base_uv);
    ALBEDO = albedo.rgb * albedo_tex.rgb;
    METALLIC = metallic;
    SPECULAR = specular;
    ROUGHNESS = roughness;
    RIM = rim ;
    RIM_TINT = rim_tint;
}
