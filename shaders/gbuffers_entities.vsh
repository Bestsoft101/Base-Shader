#version 120

#define DIRECTIONAL_ENTITY_LIGHT

uniform sampler2D lightmap;

uniform mat4 gbufferModelViewInverse;

uniform int entityId;

varying vec2 texcoord;
varying vec3 light;
varying vec4 color;

const vec3 lightPos = vec3(0.16169041669088866, 0.8084520834544432, -0.5659164584181102); // normalize(vec3(0.2f, 1.0f, -0.7f)), values from Beta 1.7.3
const float ambientBrightness = 0.4f;
const float lightBrightness = 0.6f;

void main() {
	color = gl_Color;
	light = texture2D(lightmap, (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy).rgb;
	texcoord = gl_MultiTexCoord0.xy;
	
	#ifdef DIRECTIONAL_ENTITY_LIGHT
	if(entityId != 10000) {
		vec3 normal = gl_NormalMatrix * gl_Normal;
		normal = (gbufferModelViewInverse * vec4(normal, 0.0f)).xyz;
		
		float entityLight = ambientBrightness;
		
		entityLight += clamp(dot(vec3(lightPos.x, lightPos.y, lightPos.z), normal), 0.0f, 1.0f) * lightBrightness;
		entityLight += clamp(dot(vec3(-lightPos.x, lightPos.y, -lightPos.z), normal), 0.0f, 1.0f) * lightBrightness;
		
		entityLight = clamp(entityLight, 0.0f, 1.0f);
		
		color.rgb *= entityLight;
		color.rgb = clamp(color.rgb, 0.0f, 1.0f);
	}
	#endif
	
	gl_Position = ftransform();
}