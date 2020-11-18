Shader "Custom/toon"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Level("Level",int) = 10
        _SpecCol("Specular Color",Color) = (1,1,1,1)
        _SpecPow("Specular Power",Range(10,200)) = 10
        _SpecCol2("Specular Color2",Color) = (1,1,1,1)
        _SpecPow2("Specular Power2",Range(10,200)) = 10
        _RimCol("RimCol",Color) = (1,1,1,1)
        _RimPow("RimPow",Range(10,200)) = 10
        _Thickness("Thickness", Range(0,0.1)) = 0.001
        _ThicknessColor("ThicknessColor (RGB)", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        cull front

        CGPROGRAM
        #pragma surface surf NoLight vertex:vert
        #pragma target 3.0

        sampler2D _MainTex;
        float _Thickness;
        float4 _ThicknessColor;
        void vert(inout appdata_full v)
        {
            v.vertex += float4(v.normal.rgb * _Thickness, v.vertex.a);
        }

        struct Input
        {
            float2 uv_MainTex;
            float4 color:Color;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
  
        }

        float4 LightingNoLight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return _ThicknessColor;
        }
        ENDCG

        cull back

        CGPROGRAM
        #pragma surface surf Toon noambient
        #pragma target 3.0

        sampler2D _MainTex;
        float4 _SpecCol;
        float _SpecPow;
        float4 _SpecCol2;
        float _SpecPow2;
        float4 _RimCol;
        float _RimPow;
        int _Level;
        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;

        }

        float4 LightingToon(SurfaceOutput s, float3 lightDir,float3 viewDir, float atten)
        {
            float4 final;
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            ndotl *= _Level;
            ndotl = ceil(ndotl) / _Level;

            float rim = dot(s.Normal, viewDir);

            float4 RimColor = max(0, pow(1 - rim, _RimPow) * _RimCol);
            RimColor = ceil(RimColor) / _Level;

            float H = normalize(s.Normal + viewDir);
            float4 SpecColor = max(0, dot(lightDir, H) * _SpecCol);
            SpecColor = pow(SpecColor, _SpecPow);
            SpecColor = ceil(SpecColor) / _Level;
;
            float4 SpecColor2 = max(0, pow(rim, _SpecPow2) * _SpecCol2);
            SpecColor2 *= _Level;
            SpecColor2 = ceil(SpecColor2) / _Level;

            final.rgb = ndotl * s.Albedo * _LightColor0.rgb + RimColor + SpecColor + SpecColor2;
            final.a = s.Alpha;



            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
