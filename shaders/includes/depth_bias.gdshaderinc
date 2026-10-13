#include "common.gdshaderinc"

#ifndef DEPTH_EPSILON
#define DEPTH_EPSILON 1e-5
#endif

#ifndef DEPTH_INSTANCE_INDEX
#define DEPTH_INSTANCE_INDEX 0
#endif

instance uniform float depth_bias :  hint_range(-1.0, 1.0, 0.00001), instance_index(DEPTH_INSTANCE_INDEX) = 0.0;

void applyDepthBias(inout vec4 position)
{
    float biased_z = position.z + depth_bias * position.w;

#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
    position.z = clamp(
        biased_z,
        -position.w + DEPTH_EPSILON,
        position.w - DEPTH_EPSILON);
#else
    position.z = clamp(
        biased_z,
        DEPTH_EPSILON,
        position.w - DEPTH_EPSILON);
#endif
}

#undef DEPTH_EPSILON
#undef DEPTH_INSTANCE_INDEX