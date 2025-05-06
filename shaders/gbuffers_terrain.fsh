#version 120
#include "/fog.glsl"

#define WORLD_FOG

uniform sampler2D texture;
uniform sampler2D depthtex0;

uniform int fogShape;

in vec2 texcoord;
in vec4 color;
in vec3 normal;
flat in vec3 position;
flat in float blockId;

void main() {
	bool noMipMap = false;
	vec4 maximumLodAlbedo = texture2DLod(texture, texcoord, 4.0);

	vec3 fractPos = fract(position);
	fractPos = mix(fractPos, vec3(1.0), vec3(lessThan(fractPos, vec3(0.01))));

	if (maximumLodAlbedo.a < 0.72 && ((
		//(abs(normal.r) > 0.1 && abs(normal.r) < 0.9) ||
		(fractPos.x < 0.99 || fractPos.y < 0.99 || fractPos.z < 0.99)
		// weird-shaped blocks that are caught by this but still should be mipmapped
		&& blockId != 1.0
		// transparent full blocks that also should be mipmapped
	) || blockId != 2.0)) {
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