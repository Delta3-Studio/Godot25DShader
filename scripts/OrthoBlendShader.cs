#pragma warning disable S3218
// ReSharper disable MemberHidesStaticFromOuterClass
using System.Runtime.CompilerServices;

public static class OrthoBlendShader
{
    public static class ParamNames
    {
        public static readonly StringName Enabled = "OrthoBlendEnabled";
        public static readonly StringName CameraDistance = "CameraDistance";
        public static readonly StringName Fov = "CameraFOV";
        public static readonly StringName Minimum = "OrthoBlendMinimum";
    }

    static readonly CurrentValues _values = new();

    public static bool Enabled
    {
        get => _values.Enabled;
        set
        {
            if (_values.Enabled == value) return;
            _values.Enabled = value;
            Set(ParamNames.Enabled, _values.Enabled);
        }
    }

    public static float CameraDistance
    {
        get => _values.CameraDistance;
        set
        {
            if (Mathf.IsEqualApprox(_values.CameraDistance, value)) return;
            _values.CameraDistance = Mathf.Abs(value);
            Set(ParamNames.CameraDistance, _values.CameraDistance);
        }
    }

    public static float Fov
    {
        get => _values.Fov;
        set
        {
            if (Mathf.IsEqualApprox(_values.Fov, value)) return;
            _values.Fov = value;
            Set(ParamNames.Fov, _values.Fov);
        }
    }

    public static float Minimum
    {
        get => _values.Minimum;
        set
        {
            _values.Minimum = value;
            Set(ParamNames.Minimum, _values.Minimum);
        }
    }

#if TOOLS
    public static bool EditorEnabled
    {
        get => RenderingServer.GlobalShaderParameterGet(ParamNames.Enabled).AsBool();
        set => Set(ParamNames.Enabled, value);
    }
#endif

    public static void Toggle() => Enabled = !_values.Enabled;

    public static void Init()
    {
        _values.Enabled = GetDefault(ParamNames.Enabled).AsBool();
        _values.CameraDistance = GetDefault(ParamNames.CameraDistance).AsSingle();
        _values.Fov = GetDefault(ParamNames.Fov).AsSingle();
        _values.Minimum = GetDefault(ParamNames.Minimum).AsSingle();
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    static void Set(StringName name, Variant value) => RenderingServer.GlobalShaderParameterSet(name, value);

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    static Variant GetDefault(StringName name) => ProjectSettings.Singleton.GetShaderGlobalDefault(name);

    sealed class CurrentValues
    {
        public bool Enabled;
        public float CameraDistance;
        public float Fov;
        public float Minimum;
    }
}
