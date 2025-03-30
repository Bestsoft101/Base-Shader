#version 120

#define SKY_FOG

varying float vertexDistance;
varying vec3 position;
varying vec4 color;

uniform int fogShape;
uniform int fogMode;
uniform int renderStage;
uniform int isEyeInWater;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform float viewWidth;
uniform float viewHeight;

void main() {
	if(isEyeInWater != 0) {
		discard;
	}
	
	vec4 albedo = color;
	
	#ifdef SKY_FOG
	if(renderStage != MC_RENDER_STAGE_SUNSET) {
		albedo.rgb = mix(albedo.rgb, gl_Fog.color.rgb, smoothstep(gl_Fog.start, gl_Fog.end, vertexDistance));
	}
	#endif
	
	gl_FragData[0] = albedo;
}