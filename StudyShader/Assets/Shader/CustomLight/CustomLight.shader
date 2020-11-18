Shader "Custom/CustomLight"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("NormalMap",2D) = "bump"{}
        _GlossTex("GlossTex",2D) = "white"{}
        _SpecCol("Specular Color",Color) = (1,1,1,1)
        _SpecPow("Specular Power",Range(10,200)) = 10
        _SpecCol2("Specular Color2",Color) = (1,1,1,1)
        _SpecPow2("Specular Power2",Range(10,200)) = 10
        _RimCol("RimCol",Color) = (1,1,1,1)
        _RimPow("RimPow",Range(10,200)) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Test  

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _GlossTex;
        float4 _SpecCol;
        float _SpecPow;
        float4 _SpecCol2;
        float _SpecPow2;
        float4 _RimCol;
        float _RimPow;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float2 uv_GlossTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Alpha = c.a;

            fixed4 g = tex2D(_GlossTex, IN.uv_GlossTex);
            o.Gloss = g.a;
        }

        float4 LightingTest(SurfaceOutput s, float3 lightDir, float3 viewDir,float atten)
        {
            float4 final;

            float3 diffColor;
            float ndotl = max(0,dot(s.Normal, lightDir));
            diffColor.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;

            float4 rimColor = _RimCol;
            float rim = max(0, dot(viewDir, s.Normal));
            rimColor *= pow((1 - rim), _RimPow);

            float3 H = normalize(viewDir + lightDir);
            float spec = max(0,dot(H, s.Normal));
            float3 specColor = pow(spec, _SpecPow) * _SpecCol;

            float3 specColor2 = pow(rim, _SpecPow2) * _SpecCol2 * s.Gloss;

            final.rgb = diffColor.rgb + rimColor + specColor + specColor2;
            final.a = s.Alpha;
            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
