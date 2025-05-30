#version 330 compatibility

uniform mat4 gbufferModelViewInverse;

out vec2 texcoord;
out vec4 glcolor;
out vec3 normal;
out vec2 lmcoord;

in vec2 mc_Entity;

flat out int isLight;
flat out int isGrass;

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	glcolor = gl_Color;
	lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	lmcoord = (lmcoord * 33.05 / 32.0) - (1.05 / 32.0);

	if(lmcoord.r < 0.9) {
		isLight = 1;
	} else {
		isLight = 0;
	}

	if(mc_Entity.x == 1) {
		isGrass = 1;
	} else {
		isGrass = 0;
	}

	normal = gl_NormalMatrix * gl_Normal;
	normal = mat3(gbufferModelViewInverse) * normal;
}