// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced '_ProjectorClip' with 'unity_ProjectorClip'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "T4M/PreviewT4M" { 
Properties {
 	_Transp ("Transparency", Range(0,1)) = 1 
	_MainTex ("Texture", 2D) = "" { }
	_MaskTex ("Mask (RGB) Trans (A)", 2D) = "" { }
	 _Tiling("Texture Tiling x/y", Vector)=(1,1,0,0)
	}
SubShader {
		Pass {
		//Blend SrcAlpha One
		Blend SrcAlpha OneMinusSrcAlpha   
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"
        
        struct v2f {
            float4 pos : SV_POSITION;
             float4 uv1 : TEXCOORD0;
            float4 uv2 : TEXCOORD1;
             float4 uv3 : TEXCOORD2;
        };
		float4x4 unity_Projector;
		float4x4 unity_ProjectorClip;
		float _Transp;
        sampler2D _MaskTex;
        sampler2D _MainTex;
        float4 _Tiling;
       // v2f vert (float4 v : POSITION)
       v2f vert(appdata_full v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);

            // TexGen ObjectLinear:
            // use object space vertex position
            o.uv1 = v.texcoord;
            o.uv2 = mul(unity_Projector,v.vertex);
            o.uv3 = mul(unity_ProjectorClip,v.vertex);
            return o;
        }
        
        half4 frag (v2f i) : SV_Target
        {
        	float2 uv = float2(i.uv2.x *_Tiling.x,i.uv2.y *_Tiling.y);
        	half4 col =tex2D(_MainTex, UNITY_PROJ_COORD(uv));//tex2D(_MainTex, i.uv1.xy);
        	half4 mask =tex2Dproj (_MaskTex,UNITY_PROJ_COORD(i.uv2));
        	half4 res = col*mask.a;
        	res *= (half)_Transp;
            return res;
        }
        ENDCG 
    	} 
	}	
}
