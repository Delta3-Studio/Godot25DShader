shader_type spatial;
render_mode depth_draw_opaque, cull_back,  unshaded;

uniform vec4 albedo : source_color;
uniform float grow : hint_range(-16.0, 16.0, 0.001);
#include "includes/depth_bias.gdshaderinc"
#include "includes/ortho_blend.gdshaderinc"

void vertex() {
    VERTEX += NORMAL * grow;
    APPLY_VERTEX_ORTHO_BLEND
    applyDepthBias(POSITION);
}

void fragment() {
    ALBEDO = albedo.rgb;
    ALPHA *= albedo.a;
}
