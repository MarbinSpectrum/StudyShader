Shader "Custom/Alpha2Pass"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RimColor("Color", Color) = (1,1,1,1)
        _RimPower("RimPower", Range(1,10)) = 3
        _Holo("Holo", float) = 3
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

        zwrite on
        ColorMask 0
        CGPROGRAM
        #pragma surface surf nolight noambient noforwardadd nolightmap novertexlights noshadow
        struct Input
        {
            float2 color:COLOR;
        };
        void surf (Input IN, inout SurfaceOutput o)
        {

        }
        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, 0);
        }
        ENDCG

        zwrite off
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        sampler2D _MainTex;
        float _RimPower;
        float _Holo;
        fixed4 _RimColor;
        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };
        void surf(Input IN, inout SurfaceOutput o)
        {
            float rim = dot(o.Normal, IN.viewDir);
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * _RimColor;
            o.Emission = pow(1 - rim, _RimPower) * _RimColor;
            float d = pow(1 - rim, _RimPower) + pow(frac(IN.worldPos.y* _Holo + _Time.y), 30);
            o.Alpha = d;

        }

 
        ENDCG
    }
    FallBack "Diffuse"
}
