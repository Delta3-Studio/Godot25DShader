using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

public static class DepthShader
{
    public static readonly StringName ParamName = "depth_bias";

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    static void SetInstanceParam(GeometryInstance3D geometry, Variant bias) =>
        geometry.SetInstanceShaderParameter(ParamName, bias);

    public static void SetDepthBias(GeometryInstance3D geometry, float bias) => SetInstanceParam(geometry, bias);

    public static void SetDepthBias(ReadOnlySpan<GeometryInstance3D> geometries, float bias)
    {
        Variant depthBias = bias;
        ref var current = ref MemoryMarshal.GetReference(geometries);
        ref var limit = ref Unsafe.Add(ref current, geometries.Length);
        while (Unsafe.IsAddressLessThan(ref current, ref limit))
        {
            SetInstanceParam(current, depthBias);
            current = ref Unsafe.Add(ref current, 1);
        }
    }
}
