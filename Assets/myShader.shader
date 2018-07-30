// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Cube Shader"{

	// Define variables
	Properties{
		_MainTexture("Main Texture", 2D) = "white" {}
		_Color("Main Colour (RGBA)", Color) = (1, 1, 1, 1)

		_ExtrudeAmount("Extrude Amount", Range(-3, 3)) = 0.3 
	}


		// Several sub shaders possible. One for each platform for instance(iOS, Android, PC, Mac etc.).
	SubShader{

			// Mulitple passes possible. Use as less as possible. Each pass does computation and renders more. 
			// Each pass equates to one draw call.
		Pass{

			// Open and close a CG block
			CGPROGRAM

				// Define the vertex and fragment funtions
				#pragma vertex vertexFunction
				#pragma fragment fragmentFunction 

				#include "UnityCG.cginc"

				// Get data first
				// UV, vertices, colour, normal etc.
				// Colour would be RGBA so use float4.
				struct appdata {
					float4 vert : POSITION;
					float2 uv : TEXCOORD0;
					float3 normal : NORMAL;
				};
			
				struct v2f {
					float4 position : SV_POSITION;
					float2 uv : TEXCOORD0;
				};
			
				// Import texture properties defined before.
				float4 _Color;
				sampler2D _MainTexture;
				float _ExtrudeAmount;

				// Vertex Function
				// Build Objects from our Data
				v2f vertexFunction(appdata IN) {
					v2f OUT;

					IN.vert.xyz += IN.normal.xyz * _ExtrudeAmount * sin(_Time.y);
					OUT.position = UnityObjectToClipPos(IN.vert);
					OUT.uv = IN.uv;
					
					return OUT;
				}
			

				// Fragment Function
				// Colour our object!!
				fixed4 fragmentFunction(v2f IN) : SV_Target{

					float4 textureColour = tex2D(_MainTexture, IN.uv);
					
					return textureColour * _Color;
				}

			ENDCG

		}
				
	}

}