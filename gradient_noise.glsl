#include "base_noise.glsl"

float rCorner(vec2 i, vec2 f, vec2 d)
{
    return dot(normalize(rand2d(i + d)), f - d);
}

float rCorner3d(vec3 i, vec3 f, vec3 d)
{
    return dot(rand3d(i + d), f - d);
}

float gradientNoise(vec2 xy, int mode)
{
    vec2 i = floor(xy);
    vec2 f = fract(xy);

    float r00 = rCorner(i, f, vec2(0, 0));
    float r10 = rCorner(i, f, vec2(1, 0));
    float r01 = rCorner(i, f, vec2(0, 1));
    float r11 = rCorner(i, f, vec2(1, 1));

    vec2 u = makeFraction(vec3(xy, 0), mode).xy;
    float rx0 = mix(r00, r10, u.x);
    float rx1 = mix(r01, r11, u.x);

    return mix(rx0, rx1, u.y) * 0.5 + 0.5;
}

float magic(vec2 i, vec2 f, vec2 d)
{
    return (dot(rand2d(i + d), f ));
}

vec2 n(vec2 x) {
    return normalize(x);
}
vec3 gradientNoiseSandbox(vec2 xy, int mode)
{
    vec2 i = floor(xy);
    vec2 f = fract(xy);

    float r00 = magic(i, (f), vec2(0, 0));
    float r10 = magic(i, (f), vec2(1, 0));
    float r01 = magic(i, (f), vec2(0, 1));
    float r11 = magic(i, (f), vec2(1, 1));

    vec2 u = makeFraction(vec3(xy, 0), mode).xy;
    float rx0 = mix(r00, r10, u.x);
    float rx1 = mix(r01, r11, u.x);
    float r =  mix(rx0, rx1, u.y); // * 0.5 + 0.5;

    return vec3(r);
}

float gradientNoise3d(vec3 xyz, int mode)
{
    vec3 i = floor(xyz);
    vec3 f = fract(xyz);
    vec3 u = makeFraction(xyz, mode);

    float z0;
    {
        float t = mix(rCorner3d(i, f, vec3(0, 0, 0)), rCorner3d(i, f, vec3(1, 0, 0)), u.x);
        float b = mix(rCorner3d(i, f, vec3(0, 1, 0)), rCorner3d(i, f, vec3(1, 1, 0)), u.x);
        z0 = mix(t, b, u.y);
    }

    float z1;
    {
        float t = mix(rCorner3d(i, f, vec3(0, 0, 1)), rCorner3d(i, f, vec3(1, 0, 1)), u.x);
        float b = mix(rCorner3d(i, f, vec3(0, 1, 1)), rCorner3d(i, f, vec3(1, 1, 1)), u.x);
        z1 = mix(t, b, u.y);
    }

    return mix(z0, z1, u.z) * 0.5 + 0.5;
}

float gradientOctaveNoise(vec2 xy, int mode)
{
    float noise;
    int lowerBound = 1;
    int upperBound = 10;
    float amplitudes[10] = float[10](1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0);
    float sum = 0.0;
    for (int power = lowerBound; power <= upperBound; power++) {
        vec2 x = xy * float(1<<power);
        noise += gradientNoise(x, mode) * amplitudes[power - 1];
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
    vec2 xy = uv2coord(uv);
    vec3 xyz = vec3(xy, iGlobalTime * 0.25);

    float noise;
    vec3 color = vec3(noise);
    {
        // color = gradientNoiseSandbox(5.0 * awUV, 3);
        // color = smoothstep(1.0, 0.0, color);
        // noise = smoothstep(0.0, 1.0, noise);
        // noise = smoothstep(0.0, 1.0, noise);
        // noise = smoothstep(0.0, 1.0, noise);
        // noise = gradientOctaveNoise(uv, 3);

        // noise = noise2d(128.0 * uv, 3);
    }
    {
        vec2 xy = 5.0 * awUV;
        vec2 i = floor(xy);
        vec2 f = fract(xy);

        vec2 r = rand2d(vec2(i.x, 0));

        color = vec3(dot(vec2(f.x, 0), r));
    }
    // {
    //     noise = gradientNoise3d(5.0 * xyz, 3);
    // }
    // {
    //     vec3 xyz = vec3(uv * 10.0, iGlobalTime * 1.0);
    //     noise = noise3d2(xyz, 3);
    // }

    // uv *= 5.0;
    // uv = fract(uv);
    // color = vec3(uv, 0);

    gl_FragColor = vec4(color, 1);
}