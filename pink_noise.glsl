#include "base_noise.glsl"

float pinkNoise(vec2 xy, int mode)
{
    float noise;
    int lowerBound = 1;
    int upperBound = 10;
    float amplitudes[10] = float[10](10.0,9.0,8.0,7.0,6.0,5.0,4.0,3.0,2.0,1.0);
    float sum = 0.0;
    for (int power = lowerBound; power <= upperBound; power++) {
        vec2 x = xy * float(1<<power);
        noise += noise2d(x, mode) * amplitudes[power - 1];
        sum += amplitudes[power - 1];
    }
    return noise / sum;
}

float pinkNoise3d(vec3 xyz, int mode)
{
    float noise;
    int lowerBound = 1;
    int upperBound = 10;
    float amplitudes[10] = float[10](10.0,9.0,8.0,7.0,6.0,5.0,4.0,3.0,2.0,1.0);
    float sum = 0.0;
    for (int power = lowerBound; power <= upperBound; power++) {
        vec3 x = xyz * float(1<<power);
        noise += noise3d(x, mode) * amplitudes[power - 1];
        sum += amplitudes[power - 1];
    }
    return noise / sum;
}

void main()
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;
    vec2 awUV = apsectAwareUV(uv, iResolution.xy);
    vec2 coord = uv2coord(uv);
    float noise;
    {
        noise = pinkNoise(uv, 3);
    }
    // {
    //     vec3 xyz = vec3(uv * 4.0, iGlobalTime * 0.25);
    //     noise = pinkNoise3d(xyz, 2);
    // }
    gl_FragColor = vec4(vec3(noise), 1);
}