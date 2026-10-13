#include "common.gdshaderinc"

global uniform float CameraDistance = 5.4;
global uniform float CameraFOV = 32.0;
global uniform float OrthoBlendMinimum : hint_range(0.0, 1.0) = 0.7;
global uniform bool OrthoBlendEnabled = true;

uniform float ortho_blend : hint_range(0.0, 1.0) = 0;

vec2 getFov(vec2 vp_size) {
    float aspect = vp_size.x / vp_size.y;
    float fov_y = radians(CameraFOV);
    float fov_x = 2.0 * atan(tan(fov_y * 0.5) * aspect);
    return vec2(fov_x, fov_y);
}

#define COMPUTE_VERTEX_ORTHO_BLEND_POSITION \
    mat4 CLIP_MATRIX = PROJECTION_MATRIX * VIEW_MATRIX; \
    mat4 INV_CLIP_MATRIX = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX; \
    \
    vec4 camera = INV_VIEW_MATRIX[3]; \
    vec3 camera_pos = camera.xyz; \
    vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; \
    vec3 relative_pos = world_pos - camera_pos; \
    vec4 clip_pos = CLIP_MATRIX * vec4(relative_pos, 0.0); \
    \
    vec2 fov = getFov(VIEWPORT_SIZE); \
    vec2 view_size = CameraDistance * tan(fov * 0.5); \
    vec3 ortho_vector = VIEW_MATRIX[0].xyz / view_size.x; \
    /* Apply ortho blending */ \
    float blend_amount = OrthoBlendEnabled ? max(ortho_blend, OrthoBlendMinimum) : 0.0; \
    float ortho_value = dot(ortho_vector, relative_pos) * clip_pos.w; \
    vec4 ortho_clip_pos = vec4(mix(clip_pos.x, ortho_value, blend_amount), clip_pos.yzw); \
    vec4 final_pos = camera + (INV_CLIP_MATRIX * ortho_clip_pos); \
    POSITION = CLIP_MATRIX * final_pos; \

#define APPLY_VERTEX_ORTHO_BLEND \
    if(IN_SHADOW_PASS || !OrthoBlendEnabled) { COMPUTE_VERTEX_POSITION  } else { COMPUTE_VERTEX_ORTHO_BLEND_POSITION  }