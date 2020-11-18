Shader "Custom/Rim"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("NormalMap", 2D) = "bump" {}
        _RimColor("Color", Color) = (1,1,1,1)
        _RimPower("RimPower", Range(1,10)) = 3

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Lambert noambient

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NormalMap;
        float _RimPower;
        fixed4 _RimColor;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float3 viewDir;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            float rim = dot(o.Normal, IN.viewDir);
            o.Emission = pow(1- rim, _RimPower)* _RimColor;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
