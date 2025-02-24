#version 120

uniform int fogShape;

varying float vertexDistance;
varying vec3 position;
varying vec4 color;

void main() {
	position = gl_Vertex.xyz;
	color = gl_Color;
	
	if(fogShape == 1) {
		vertexDistance = max(length(position.xz), abs(position.y));
	}else{
		vertexDistance = length(position.xyz);
	}
	
	gl_Position = ftransform();
}
