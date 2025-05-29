#version 330 compatibility
#include "/lib/settings.glsl"

uniform sampler2D lightmap;
uniform sampler2D gtexture;
uniform vec4 entityColor;

uniform float alphaTestRef = 0.1;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0,3 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 aoBuffer;

void main() {
	color = texture(gtexture, texcoord) * glcolor;
	color.rgb = mix(color.rgb, entityColor.rgb, entityColor.a);
	color *= clamp(pow(texture(lightmap, lmcoord), vec4(1.1)), 0.0, 1.0);
	if (color.a < alphaTestRef) {
		discard;
	}

	aoBuffer = vec4(vec3(0.0), clamp(pow(glcolor.a, 1+((GAMMA/100)*0.4)), 0.0, 1.0));
}