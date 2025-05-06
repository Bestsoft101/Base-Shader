#version 120

uniform float alphaTestRef;

in vec4 tint;

void main() {
	vec4 color = tint;
	if (color.a < alphaTestRef) discard;

	gl_FragData[0] = color;
}