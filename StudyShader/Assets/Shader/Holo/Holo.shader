Shader "Custom/Holo"
{
    Properties
    {
        _Normal("Normal", 2D) = "bump"{}
        _RimColor ("RimColor", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"= "Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _Normal;
        struct Input
        {
            float3 viewDir;
            float2 uv_Normal;
            float3 worldPos;
        };

        fixed4 _RimColor;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
            o.Emission = _RimColor;
            float rim = max(0,dot(o.Normal , IN.viewDir));
            rim = pow(1 - rim, 3) + pow(frac(IN.worldPos.g * 2 - _Time.y), 30);
            o.Alpha = rim;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
