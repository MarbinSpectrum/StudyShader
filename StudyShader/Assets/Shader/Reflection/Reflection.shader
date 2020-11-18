Shader "Custom/Reflection"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cube ("Cubemap",Cube) = ""{}
        _Normal("Normal",2D) = "bump"{}
        _ReflectMask("ReflectMask", 2D) = "white" {}
        _ReflectValue("ReflectValue",Range(0,1)) = 0.5
        _AlbedoValue("AlbedoValue",Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert noambient
        #pragma target 3.0

        sampler2D _MainTex;
        samplerCUBE _Cube;
        sampler2D _Normal;
        sampler2D _ReflectMask;
        float _ReflectValue;
        float _AlbedoValue;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Normal;
            float2 uv_ReflectMask;
            float3 worldRefl;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 re = texCUBE(_Cube, WorldReflectionVector(IN,o.Normal));
            float4 rm = tex2D(_ReflectMask, IN.uv_ReflectMask);
            o.Albedo = c.rgb * _AlbedoValue * (1- rm);
            o.Emission = re.rgb * _ReflectValue * rm;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
