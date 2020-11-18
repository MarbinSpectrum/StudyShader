Shader "Custom/OnlyTex"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SubTex("Albedo (RGB)", 2D) = "white" {}
        _Lerp("Lerp",Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SubTex;
        float _Lerp;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SubTex;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_SubTex, IN.uv_SubTex);
            o.Albedo = lerp(c.rgb,d.rgb, 1 - c.a);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
