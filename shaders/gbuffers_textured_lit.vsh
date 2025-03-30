#version 120

//#define BLOCK_LIGHT_BRIGHTNESS_FIX

uniform sampler2D lightmap;

varying vec2 texcoord;
varying vec4 color;

void main() {
	#ifdef BLOCK_LIGHT_BRIGHTNESS_FIX
	color = gl_Color * texture2D(lightmap, clamp(gl_MultiTexCoord1.xy / vec2(255.0f, 247.0f), 0.5f / 16.0f, 15.5f / 16.0f));
	#else
	color = gl_Color * texture2D(lightmap, clamp(gl_MultiTexCoord1.xy / 255.0f, 0.5f / 16.0f, 15.5f / 16.0f));
	#endif
	texcoord = gl_MultiTexCoord0.xy;
	
	gl_Position = ftransform();
}