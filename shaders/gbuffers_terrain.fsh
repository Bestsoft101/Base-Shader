#version 120

#define almost45Deg(a) (abs(a - 0.70710677) < 0.3)
#define almostMinus45Deg(a) (abs(a + 0.70710677) < 0.3)

#define WORLD_FOG

uniform sampler2D texture;

uniform float viewWidth;
uniform float viewHeight;

uniform int fogShape;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

in vec2 texcoord;
in vec4 color;
in vec3 normal;
flat in float blockId;

#ifdef WORLD_FOG
#include "fog.glsl"
#endif

void main() {
	bool noMipMap = false;
	vec4 maximumLodAlbedo = texture2DLod(texture, texcoord, 4.0);

	// exclude exceptions to these rules
	if (blockId != 1.0 &&
	 // detect cross-shaped blocks; almost all cross-shaped blocks have mipmaps and anisotropic filtering disabled
	 ((abs(normal.g) < 0.001
	 && ((almostMinus45Deg(normal.r) && almostMinus45Deg(normal.b)) //north-west face
	  || (almostMinus45Deg(normal.r) && almost45Deg(normal.b)) //south-west face
	  || (almost45Deg(normal.r) && almostMinus45Deg(normal.b)) //south-east face
	  || (almost45Deg(normal.r) && almost45Deg(normal.b)))) //north-east face
	  // some other blocks have mipmaps disabled
	 || blockId == 2.0
	  // other translucent blocks, also have mipmaps disabled.
	 || maximumLodAlbedo.a < 0.85)) {
		noMipMap = true;
	}
	
	vec4 albedo = noMipMap
					? texture2DLod(texture, texcoord, 0.0) * color
					: texture2D(texture, texcoord) * color;
	
	#ifdef WORLD_FOG
	albedo.rgb = mix(albedo.rgb, gl_Fog.color.rgb, getFogStrength(fogShape, gl_Fog.start, gl_Fog.end));
	#endif
	
	gl_FragData[0] = albedo;
}