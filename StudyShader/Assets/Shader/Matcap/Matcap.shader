Shader "Custom/Matcap"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Normal("Normal", 2D) = "white" {}
        _Matcap("Matcap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf nolight noambient

        sampler2D _MainTex;
        sampler2D _Normal;
        sampler2D _Matcap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Normal;
            float3 worldNormal;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
            float3 worldNor = WorldNormalVector(IN, o.Normal);
            float3 viewNormal = mul((float3x3)UNITY_MATRIX_V, worldNor);
            float2 MatcapUV = viewNormal.xy * 0.5 + 0.5;
            o.Emission = tex2D(_Matcap, MatcapUV) * c;
            o.Alpha = c.a;
        }

        float4 Lightingnolight(SurfaceOutput s, float lightDir, float atten)
        {
            return float4(0, 0, 0, s.Alpha);
        }

        ENDCG
    }
    FallBack "Diffuse"
}
