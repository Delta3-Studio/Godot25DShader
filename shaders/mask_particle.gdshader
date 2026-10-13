shader_type spatial;
render_mode unshaded, cull_disabled, depth_prepass_alpha;
#include "includes/depth_bias.gdshaderinc"

uniform sampler2D Base_Texture : source_color;
uniform bool billboard = false;

void vertex() {
     if (billboard) {
        // based on node: GetBillboardMatrix:2
        float angle = INSTANCE_CUSTOM.x;
        float c = cos(angle);
        float s = sin(angle);
        float scale_x = length(MODEL_MATRIX[0].xyz);
        float scale_y = length(MODEL_MATRIX[1].xyz);
        float scale_z = length(MODEL_MATRIX[2].xyz);
        vec3 right   = normalize(INV_VIEW_MATRIX[0].xyz);
        vec3 up      = normalize(INV_VIEW_MATRIX[1].xyz);
        vec3 forward = normalize(INV_VIEW_MATRIX[2].xyz);
        vec3 rotated_right = (right * c - up * s) * scale_x;
        vec3 rotated_up    = (right * s + up * c) * scale_y;
        vec3 rotated_fwd   = forward * scale_z;

        MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
            vec4(rotated_right, 0.0),
            vec4(rotated_up,    0.0),
            vec4(rotated_fwd,   0.0),
            MODEL_MATRIX[3]
        );
    }

    COMPUTE_VERTEX_POSITION
    applyDepthBias(POSITION);
}

void fragment() {
    vec4 color = COLOR;
    float alpha = color.a;
    vec4 tex = texture(Base_Texture, UV);
    float mask_channel = tex.r;

    ALBEDO = vec3(color.rgb);
    ALPHA = mask_channel * alpha;
}
