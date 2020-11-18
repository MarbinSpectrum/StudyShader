Shader "Custom/Surface"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Metallic("Metallic",Range(0,1)) = 0
        _Smoothness("Smoothness",Range(0,1)) = 0.5
        _BumpMap("NormalMap",2D) = "bump"{}
        _BumpValue("BumpValue",Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float _Metallic;
        float _Smoothness;
        float _BumpValue;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float3 n = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Normal = float3(n.r * _BumpValue, n.g * _BumpValue, n.b);
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
