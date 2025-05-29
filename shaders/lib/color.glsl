float getLuminance(vec3 rgb) {
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    return dot(rgb, W);
}

vec3 BSC(vec3 color, float brt, float sat, float con)
{
	const float AvgLumR = 0.5;
	const float AvgLumG = 0.5;
	const float AvgLumB = 0.5;
	
	const vec3 LumCoeff = vec3(0.2125, 0.7154, 0.0721);
	
	vec3 AvgLumin  = vec3(AvgLumR, AvgLumG, AvgLumB);
	vec3 brtColor  = color * brt;
	vec3 intensity = vec3(dot(brtColor, LumCoeff));
	vec3 satColor  = mix(intensity, brtColor, sat);
	vec3 conColor  = mix(AvgLumin, satColor, con);
	
	return conColor;
}