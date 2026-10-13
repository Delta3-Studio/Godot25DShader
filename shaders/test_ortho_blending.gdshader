shader_type spatial;

uniform vec3 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

#include "includes/depth_bias.gdshaderinc"
#include "includes/ortho_blend.gdshaderinc"

void vertex() {
    APPLY_VERTEX_ORTHO_BLEND
    applyDepthBias(POSITION);
}

void fragment() {
    vec4 tex = texture(texture_albedo, UV);
    ALBEDO = tex.rgb * albedo;
}