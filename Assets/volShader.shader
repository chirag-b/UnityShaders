// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Sample 3D Texture" {
	Properties{
		_Volume("Texture", 3D) = "" {}
		radius("Radius", float) = 1
		_centre("Centre", vector) = (0,0,0)
	}

	SubShader{
		Pass{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers flash gles

			#include "UnityCG.cginc"

			#define STEPS 700
			#define STEP_SIZE 0.01

			struct appdata {
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			float3 _centre;
			float radius;

			//Need to fill this up
			struct v2f {
				float4 pos : SV_POSITION; //position within the clip space.
				float3 uv : TEXCOORD0; //texture co-ordinates.
				float3 wPos : TEXCOORD1;
			};

			v2f vert(appdata IN)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(IN.vertex);
				//o.uv = IN.vertex.xyz*0.5 + 0.5;
				o.wPos = mul(unity_ObjectToWorld, IN.vertex).xyz;
				//o.uv = IN.uv.xyzw*0.5 + 0.5;
				return o;
			}

			sampler3D _Volume;

			bool sphereHit(float3 p) {
				return distance(p, _centre) < radius;
			}

			bool raycastHit(float3 position, float3 direction) {
				for (int i = 0; i < STEPS; i++) {
					
					if (sphereHit(position)) {
						//return float4(1, 0, 0, 1); // Red
						return true;
					}
					position += direction * STEP_SIZE;
				}
				//return float4(0, 0, 0, 1); // White
				return false;
			}

			float4 frag(v2f i) : COLOR
			{
				//Direction

				float3 worldPosition = i.wPos;
				float3 viewDirection = normalize(worldPosition - _WorldSpaceCameraPos);

				//fixed4 x = raymarch(worldPosition, viewDirection);

				if (raycastHit(worldPosition, viewDirection))
					return fixed4(1,0,0,1); // Red if hit the ball
					//return tex3D(_Volume, worldPosition);
				else
					return fixed4(1,1,1,1); // White otherwise
				//float4 colouredPixel = tex3D(_Volume, i.uv);

				//return colouredPixel;
				
			}
			ENDCG
		}
	}

	Fallback Off
}