Shader "Custom/Blink"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BlinkMask("BlinkMask", 2D) = "white" {}
        _BlinkData("BlinkData", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BlinkMask;
        sampler2D _BlinkData;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BlinkMask;
            float2 uv_BlinkData;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 m = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 bm = tex2D(_BlinkMask, IN.uv_BlinkMask);
            fixed4 bd = tex2D(_BlinkData, float2(_Time.y,0.5));
            o.Albedo = m.rgb;
            o.Emission = m.rgb * bm.g * bd.r;
            o.Alpha = m.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
