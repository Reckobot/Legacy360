#version 330 compatibility
#include "/lib/settings.glsl"
#include "/lib/color.glsl"

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D depthtex0;

uniform vec3 fogColor;
uniform float far;
uniform int isEyeInWater;
uniform mat4 gbufferProjectionInverse;

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
    vec4 homPos = projectionMatrix * vec4(position, 1.0);
    return homPos.xyz / homPos.w;
}

void main() {
	color = texture(colortex0, texcoord);

	if(texture(depthtex0, texcoord).r < 1.0) {
		float depth = texture(depthtex0, texcoord).r;

		if(depth < 1) {
			color.rgb *= texture(colortex3, texcoord).a;
		}

		if(texture(colortex4, texcoord) == vec4(0.0)) {
			vec3 NDCPos = vec3(texcoord.xy, depth) * 2.0 - 1.0;
			vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);
			float dist = length(viewPos) / far;
			dist *= 2;
			float density = 1.5;
			if(texture(colortex2, texcoord).rgb != vec3(0.0)) {
				dist /= 2;
			}
			if(isEyeInWater == 1) {
				dist *= 6;
				density /= 4;
			}
			float fogFactor = exp(-density * (1.0 - dist));
			color.rgb = mix(color.rgb, fogColor, clamp(fogFactor, 0.0, 1.0));
		}
	}
	color.rgb = pow(color.rgb, vec3(1-((GAMMA/100)*0.4)));
	color.rgb = BSC(color.rgb, BRIGHTNESS/100, SATURATION/100, CONTRAST/100);
}