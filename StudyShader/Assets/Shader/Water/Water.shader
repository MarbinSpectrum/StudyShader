Shader "Custom/Water"
{
    Properties
    {
        _Normal ("Normal",2D) = "bump"{}
        _Cube   ("Cube",Cube) = ""{}
        _SPColor("Specular Color",Color) = (1,1,1,1)
        _SPPower("Specular Power",Range(50,300)) = 150
        _SPMulti("Specular Multi",Range(1,10)) = 3
        _WaveH("Wave Height",Range(0,0.5)) = 0.1
        _WaveL("Wave Length",Range(5,20)) = 12
        _WaveT("Wave Timing",Range(0,10)) = 1
        _Refract("Refract Strength",Range(0,0.2)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        GrabPass{}
            cull off
        CGPROGRAM
        #pragma surface surf specLight vertex:vert

        samplerCUBE _Cube;
        sampler2D _Normal;
        sampler2D _GrabTexture;
        float4 _SPColor;
        float _SPPower;
        float _SPMulti;
        float _WaveH;
        float _WaveL;
        float _WaveT;
        float _Refract;
        void vert(inout appdata_full v)
        {
            float movement;
            movement = sin(abs((v.texcoord.x * 2 - 1) * _WaveL) + _Time.y * _WaveT) * 
                _WaveH + sin(abs((v.texcoord.y * 2 - 1) * _WaveL) + _Time.y * _WaveT) * _WaveH;
            v.vertex.y += movement / 2;
        }

        struct Input
        {
            float2 uv_Normal;
            float3 worldRefl;
            float3 viewDir;
            float4 screenPos;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 normal1 = UnpackNormal(tex2D(_Normal, IN.uv_Normal + _Time.x * 0.1));
            float3 normal2 = UnpackNormal(tex2D(_Normal, IN.uv_Normal - _Time.x * 0.1));
            o.Normal = (normal1 + normal2) / 2;

            float3 refcolor = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
            
            float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
            float3 refraction = tex2D(_GrabTexture, (screenUV.xy + o.Normal.xy * _Refract));

            float rim = max(0, dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, 1.5);

            o.Emission = (refcolor * rim + refraction)*0.5;
            o.Alpha = 1;
        }

        float4 LightingspecLight(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float3 H = normalize(lightDir + viewDir);
            float spec = max(0,dot(H, s.Normal));
            spec = pow(spec, _SPPower);
            float4 finalColor;
            finalColor.rgb = spec * _SPColor.rgb * _SPMulti;
            finalColor.a = s.Alpha + spec;
            
            return finalColor;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Vertexlit"
}
